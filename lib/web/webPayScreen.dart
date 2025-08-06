import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/collectionProvider.dart';
import '../providers/transaction.dart';

class WebPayAmountScreen extends StatefulWidget {
  final String? userid;

  final Map? user;
  final String? custName;

  const WebPayAmountScreen({
    Key? key,
    this.userid,
    this.user,
    this.custName,
  }) : super(key: key);

  @override
  _WebPayAmountScreenState createState() => _WebPayAmountScreenState();
}

class _WebPayAmountScreenState extends State<WebPayAmountScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  bool _isLoading = false;
  String selectedValue = 'Gold';

  // Controllers
  TextEditingController taxCntrl = TextEditingController();
  TextEditingController amcCntrl = TextEditingController();
  TextEditingController amountCntrl = TextEditingController();
  TextEditingController grampPerdayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Transaction model
  var _transaction = TransactionModel(
    id: '',
    customerName: '',
    customerId: '',
    date: DateTime.now(),
    amount: 0,
    transactionType: 0,
    note: '',
    invoiceNo: '',
    category: '',
    discount: 0,
    staffId: '',
    gramPriceInvestDay: 0,
    gramWeight: 0,
    branch: 0, merchentTransactionId: "", transactionMode: 'Direct',
    // staffName: '', staffNameonId: '',
    // staffName: '',
  );

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Set initial values based on scheme type
    if (widget.user!["schemeType"] == "Wishlist") {
      amountCntrl.text = "2000";
    } else {
      amountCntrl.text = "5000";
    }

    // Set tax and AMC if available
    taxCntrl.text = widget.user!["tax"]?.toString() ?? '0';
    amcCntrl.text = widget.user!["amc"]?.toString() ?? '0';
    grampPerdayController.text = '0.0';

    // Initialize transaction model
    _transaction = TransactionModel(
      customerName: widget.custName!,
      customerId: widget.userid!,
      date: DateTime.now(),
      amount: double.parse(amountCntrl.text),
      transactionType: 0,
      note: '',
      invoiceNo: '',
      category: selectedValue,
      discount: 0,
      staffId: '', // Will be set from shared preferences
      gramPriceInvestDay: 0,
      gramWeight: 0,
      branch: 0,
      merchentTransactionId: "", transactionMode: 'Direct', id: '',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // var _collection = CollectionModel(
  //   staffId: '',
  //   staffname: '',
  //   recievedAmount: 0,
  //   paidAmount: 0,
  //   balance: 0,
  //   date: DateTime.now(),
  //   type: 0,
  //   branch: "",
  // );
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    // Additional validation for non-Wishlist schemes
    if (widget.user!["schemeType"] != "Wishlist" &&
        double.parse(amountCntrl.text) < 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum amount required is 5000 for this scheme'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get staff info from shared preferences
      final prefs = await SharedPreferences.getInstance();

      // Update transaction with staff details
      // _transaction = _transaction.copyWith(
      //   staffId: staffDetails['id'],
      //   staffName: staffDetails['staffName'],
      //   date: selectedDate ?? DateTime.now(),
      // );

      // Save transaction
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      final data = await transactionProvider.createDirect(_transaction, 0, 0);

      // Create collection record
      // _collection = CollectionModel(
      //     staffId: _collection.staffId,
      //     staffname: _collection.staffname,
      //     recievedAmount: _transaction.amount,
      //     paidAmount: _collection.paidAmount,
      //     balance: _collection.balance,
      //     date: selectedDate ?? DateTime.now(),
      //     type: 0,
      //     branch: "");

      // await Provider.of<CollectionProvider>(context, listen: false)
      //     .create(_collection, data[3]);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment recorded successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Close screen if needed
      Navigator.of(context).pop(true);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving payment: $err'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool isRequired = true,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
            ),
            validator: validator ??
                (isRequired
                    ? (value) => value?.isEmpty ?? true ? 'Required' : null
                    : null),
          ),
          if (label == "Amount" && widget.user!["schemeType"] == "Wishlist")
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Fixed amount: 2000 for Wishlist",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (label == "Amount" && widget.user!["schemeType"] != "Wishlist")
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Minimum amount: 5000",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                  SizedBox(width: 12),
                  Text(
                    selectedDate == null
                        ? DateFormat('MMM dd, yyyy').format(now)
                        : DateFormat('MMM dd, yyyy').format(selectedDate!),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Receipt',
          style: TextStyle(color: TColo.primaryColor2),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TColo.primaryColor1,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Info
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColo.primaryColor1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text('Name: ${widget.custName ?? 'N/A'}',
                                    style: TextStyle(fontSize: 14)),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text('ID: ${widget.userid ?? 'N/A'}',
                                    style: TextStyle(fontSize: 14)),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Scheme: ${widget.user!["schemeType"] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Payment Form
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColo.primaryColor1,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 16),

                          // Amount
                          _buildFormField(
                            label: 'Amount',
                            controller: amountCntrl,
                            isReadOnly:
                                widget.user!["schemeType"] == "Wishlist",
                            keyboardType: TextInputType.number,
                            suffixIcon: Icon(Icons.currency_rupee, size: 20),
                          ),

                          // Description
                          _buildFormField(
                            label: 'Description',
                            controller: descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),

                          // Gram Rate
                          _buildFormField(
                            label: 'Gram Rate',
                            controller: grampPerdayController,
                            keyboardType: TextInputType.number,
                            suffixIcon: Icon(Icons.scale, size: 20),
                          ),

                          // Date
                          _buildDateField(),

                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColo.primaryColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      'Save Payment',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
