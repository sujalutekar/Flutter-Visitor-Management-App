import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adypkc/pages/single_entry_details.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF1F2FF),
      appBar: AppBar(
        // backgroundColor: const Color(0xffF1F2FF),
        title: const Text('Admin'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('entries')
            .orderBy('lastUpdated', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // print(snapshot.data?.docs.first['date']);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Data Available',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                // print('Date: ${snapshot.data?.docs[index]['date']}');

                String currentDate = snapshot.data?.docs[index]['date'];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Displaying date
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade700,
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          currentDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('entries')
                            .doc(currentDate)
                            .collection('singleDayEntries')
                            .snapshots(),
                        builder: (context, snapshot) {
                          // print(
                          //     'Total number of entries: ${snapshot.data?.docs.length}');

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text('No Data Available'),
                            );
                          }

                          // Displaying content of particular date
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                      'Total entries: ${snapshot.data!.docs.length}'),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  // print(
                                  //     'singleDayEntries: ${snapshot.data?.docs[index]['time']}');

                                  QueryDocumentSnapshot<Map<String, dynamic>>
                                      singleEntry = snapshot.data!.docs[index];
                                  String docId = snapshot.data!.docs[index].id;

                                  return Container(
                                    // margin: const EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          // tileColor: Colors.grey.shade700,
                                          onTap: () {
                                            print(singleEntry['name']);
                                            print(
                                                'SUJAL NEW DATA: ${snapshot.data?.docs[index].id}');

                                            // navigating to details page
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return SingleEntryDetails(
                                                    singleEntry: singleEntry,
                                                    docId: docId,
                                                    index: index + 1,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          leading: Hero(
                                            tag: docId,
                                            child: Text(
                                              '${index + 1}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          title: Text(
                                            singleEntry['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                              'Reason: ${singleEntry['reason']}'),
                                          trailing: Text(
                                            singleEntry['time'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
