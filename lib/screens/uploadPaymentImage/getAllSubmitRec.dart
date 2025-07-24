import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/paymentBill.dart';
import 'sendPaymentRecipt.dart';
import 'singleView.dart';

class submittedRec extends StatefulWidget {
  submittedRec({super.key, required this.userId});
  String userId;

  @override
  State<submittedRec> createState() => _submittedRecState();
}

class _submittedRecState extends State<submittedRec> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("+++++++++");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('Submitted Screenshot'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<PaymentBillProvider>(context, listen: false)
            .getAllData(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Something Error Occured'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            var documents = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 2,
                    width: MediaQuery.of(context).size.width * .7,
                  );
                },
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var data = documents[index].data() as Map<String, dynamic>;
                  var document = documents[index];
                  // Convert Timestamp to DateTime
                  DateTime dateTime = (data['date'] as Timestamp).toDate();

                  // Format the date and time
                  String formattedDate =
                      DateFormat('dd MMM yyyy').format(dateTime);
                  String formattedTime =
                      DateFormat('HH:mm:ss').format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.screenshot),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: ListTile(
                                      onTap: () {
                                        print("----666666--");
                                        print(document);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleViewPayment(
                                                      documentId: document.id,
                                                    )));
                                      },
                                      tileColor:
                                          Color.fromARGB(255, 244, 231, 214),
                                      title: Text(
                                          data['amount'].toString() ?? '0'),
                                      subtitle: Text(
                                          data['note'] ?? 'No Description'),
                                    )),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        // backgroundColor:
                                        //     const Color.fromARGB(67, 76, 175, 79),
                                        backgroundColor: data['status'] ==
                                                "Request"
                                            ? Color.fromARGB(77, 244, 67, 54)
                                            : Color.fromARGB(66, 76, 175, 79),

                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: data['status'] ==
                                                  "Request"
                                              ? Color.fromARGB(255, 199, 48, 37)
                                              : Colors.green,
                                        ),
                                      ),
                                      Text(data['status'] == "Request"
                                          ? "Pending"
                                          : "Approved")
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 38, 18, 18),
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  // ListTile(
                  //   onTap: () {
                  //     print("----666666--");
                  //     print(document);
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SingleViewPayment(
                  //                   documentId: document.id,
                  //                 )));
                  //   },
                  //   tileColor: Color.fromARGB(255, 244, 231, 214),
                  //   title: Text(data['amount'].toString() ?? '0'),
                  //   subtitle: Text(data['note'] ?? 'No Description'),
                  //   trailing: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 12,
                  //         // backgroundColor:
                  //         //     const Color.fromARGB(67, 76, 175, 79),
                  //         backgroundColor: data['status'] == "Request"
                  //             ? Color.fromARGB(77, 244, 67, 54)
                  //             : Color.fromARGB(66, 76, 175, 79),

                  //         child: CircleAvatar(
                  //           radius: 5,
                  //           backgroundColor: data['status'] == "Request"
                  //               ? Color.fromARGB(255, 199, 48, 37)
                  //               : Colors.green,
                  //         ),
                  //       ),
                  //       Text(data['status'] == "Request"
                  //           ? "Waiting for Approval"
                  //           : "Approved")
                  //     ],
                  //   ),
                  // );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
