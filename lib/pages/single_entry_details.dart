import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SingleEntryDetails extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> singleEntry;
  final String docId;
  final int index;

  const SingleEntryDetails({
    super.key,
    required this.singleEntry,
    required this.docId,
    required this.index,
  });

  @override
  State<SingleEntryDetails> createState() => _SingleEntryDetailsState();
}

class _SingleEntryDetailsState extends State<SingleEntryDetails> {
  String savedOutTime = '';

  @override
  void initState() {
    super.initState();
    getOutTime();
  }

  String calculateTotalTime(String inTime, String outTime) {
    DateFormat format = DateFormat('h:mm a');
    DateTime inDateTime = format.parse(inTime);
    DateTime outDateTime = format.parse(outTime);

    Duration difference = outDateTime.difference(inDateTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    return '$hours hours and $minutes minutes';
  }

  bool isOutTimeSaved = false;

  void getOutTime() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('entries')
        .doc(widget.singleEntry['date'])
        .collection('singleDayEntries');

    DocumentSnapshot<Object?> querySnapshot =
        await collectionRef.doc(widget.docId).get();

    String isOutTime = querySnapshot['outTime'];

    setState(() {
      savedOutTime = isOutTime;
    });

    setState(() {
      isOutTimeSaved = isOutTime.isEmpty ? false : true;
    });

    // print('outTime Present: ${isOutTime.isEmpty ? false : true}');
  }

  void saveOutTime(String outTime) {
    try {
      FirebaseFirestore.instance
          .collection('entries')
          .doc(widget.singleEntry['date'])
          .collection('singleDayEntries')
          .doc(widget.docId)
          .update({
        'outTime': outTime,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentTime =
        TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)
            .format(context);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.docId,
          child: Text('${widget.index}'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              margin: const EdgeInsets.only(top: 12),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.singleEntry['image'],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // name
            smallDetail(
                title: 'Name: ', singleEntry: widget.singleEntry['name']),

            // time
            smallDetail(
                title: 'In-Time: ', singleEntry: widget.singleEntry['time']),

            // reason
            smallDetail(
                title: 'Reason: ', singleEntry: widget.singleEntry['reason']),

            // address
            smallDetail(
                title: 'Address: ', singleEntry: widget.singleEntry['address']),

            // phone number
            smallDetail(
                title: 'Phone no: ',
                singleEntry: widget.singleEntry['phoneNumber']),

            // Out time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12)
                  .copyWith(bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Out-Time: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isOutTimeSaved ? Colors.white : Colors.grey,
                        ),
                      ),
                      Text(
                        savedOutTime.isEmpty ? currentTime : savedOutTime,
                        style: TextStyle(
                          fontSize: 16,
                          color: isOutTimeSaved ? Colors.white : Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      isOutTimeSaved == false
                          ? TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.blueGrey.shade700),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: () {
                                saveOutTime(currentTime);
                                getOutTime();
                              },
                              child: const Text('Save Out-Time'),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            isOutTimeSaved == true
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('entries')
                        .doc(widget.singleEntry['date'])
                        .collection('singleDayEntries')
                        .doc(widget.docId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // print(
                      //     'outTime Value: ${snapshot.data?['outTime'] ?? 'unknown'}');

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No Data Available'),
                        );
                      }

                      String totalTime = calculateTotalTime(
                          snapshot.data!['time'], snapshot.data!['outTime']);

                      return smallDetail(
                        title: 'Total time taken: ',
                        singleEntry: totalTime,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

Widget smallDetail({
  required String title,
  required String singleEntry,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 8),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              singleEntry,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}
