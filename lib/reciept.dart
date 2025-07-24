import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final String status;
  final String paymentId;
  final String orderId;
  final String signature;

  ReceiptPage(
      {required this.status,
      required this.paymentId,
      required this.orderId,
      required this.signature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Payment ID: $paymentId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Order ID: $orderId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Signature: $signature', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
