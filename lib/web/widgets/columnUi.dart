import 'package:flutter/material.dart';

class SchemeTableScreen extends StatelessWidget {
  const SchemeTableScreen({Key? key}) : super(key: key);

  TableRow buildRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(160),
                1: FixedColumnWidth(100),
                2: FixedColumnWidth(100),
                3: FixedColumnWidth(100),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.orange.shade100),
              ),
              children: [
                buildRow(['', '₹ 5000', '₹ 5000', '₹ 5000'], isHeader: true),
                buildRow([
                  'No. of Instalments',
                  '11 months',
                  '8 months',
                  '6 months'
                ]),
                buildRow([
                  'Total Instalment Paid',
                  '₹ 55,000',
                  '₹ 40,000',
                  '₹ 30,000'
                ]),
                buildRow(['Bonus Percentage', '100%', '50%', '25%']),
                buildRow(['Bonus Amount', '₹ 5000', '₹ 2500', '₹ 1250']),
                buildRow([
                  'Total Redemption Value',
                  '₹ 60,000',
                  '₹ 42,500',
                  '₹ 31,250'
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoldBookingTable extends StatelessWidget {
  const GoldBookingTable({Key? key}) : super(key: key);

  TableRow buildRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text(
            cell,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.orange.shade100),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(70), // Gold Rate
                1: FixedColumnWidth(50), // Month
                2: FixedColumnWidth(100), // Installment Value
                3: FixedColumnWidth(120), // Total Gold Booked
                4: FixedColumnWidth(160), // Waiver on Gold
                5: FixedColumnWidth(160), // Discount on Diamond
              },
              children: [
                buildRow([
                  'Gold Rate',
                  'Month',
                  'Instalment Value',
                  'Total Gold booked\n(in grams)',
                  '% of making charges waiver\non purchase of gold jewellery',
                  '% discount on making charges\non purchase of diamond jewellery',
                ], isHeader: true),
                buildRow(['6100', '1', '₹10,000', '1.6', '', '']),
                buildRow(['6500', '2', '₹10,000', '1.5', '', '']),
                buildRow(['6650', '3', '₹10,000', '1.5', '', '']),
                buildRow(['6600', '4', '₹10,000', '1.5', '', '']),
                buildRow(['6400', '5', '₹10,000', '1.6', '', '']),
                buildRow(['6700', '6', '₹10,000', '1.5', '', '']),
                buildRow([
                  '6850',
                  '7',
                  '₹10,000',
                  '1.5',
                  'No making charges\nUp to 10%',
                  '30%'
                ]),
                buildRow(['7100', '8', '₹10,000', '1.4', '', '']),
                buildRow([
                  '7050',
                  '9',
                  '₹10,000',
                  '1.4',
                  'No making charges\nUp to 12%',
                  '40%'
                ]),
                buildRow(['7100', '10', '₹10,000', '1.4', '', '']),
                buildRow([
                  '7200',
                  '11',
                  '₹10,000',
                  '1.4',
                  'No making charges\nUp to 16%',
                  '50%'
                ]),
                buildRow(['', 'Total', '', '16.3', '', '']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
