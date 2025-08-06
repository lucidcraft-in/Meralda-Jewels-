import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/providers/user.dart';
import 'package:provider/provider.dart';

import '../model/branchModel.dart';
import '../model/customerModel.dart';
import '../providers/branchProvider.dart';

class UserRegistrationDialog extends StatefulWidget {
  @override
  State<UserRegistrationDialog> createState() => _UserRegistrationDialogState();
}

class _UserRegistrationDialogState extends State<UserRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _placeController = TextEditingController();
  final _nomineeController = TextEditingController();
  final _nomineePhoneController = TextEditingController();
  final _nomineeRelationController = TextEditingController();
  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _custIdController = TextEditingController();

  // Dropdown values
  String? selectedSchemeType;
  final List<String> schemeTypeList = ["Wishlist", "Aspire"];
  String? selectedOdType;
  final List<String> orderAdvList = ["Gold", "Cash"];

  // Branch and country
  String? selectedBranch;
  String? selectedCountry;
  final List<String> branchList = ["Branch A", "Branch B", "Branch C"];
  final List<String> countryList = ["India", "UAE", "USA"];

  // Date fields
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  bool _showAdditionalFields = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 850),
        padding: EdgeInsets.all(isWeb ? 40 : 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // Main form fields in two columns for web
                    isWeb ? _buildWebForm() : _buildMobileForm(),

                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              // Scheme Type
              _buildDropdown(
                label: "Scheme Type",
                value: selectedSchemeType,
                items: schemeTypeList,
                onChanged: (val) => setState(() {
                  selectedSchemeType = val;
                  _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildCountryDropdown(),
                  ),
                  // Expanded(
                  //   child: _buildDropdown(
                  //     label: "Country",
                  //     value: selectedCountry,
                  //     items: countryList,
                  //     onChanged: (val) => setState(() => selectedCountry = val),
                  //   ),
                  // ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBranchDropdown())
                  // Expanded(
                  //   child: _buildDropdown(
                  //     label: "Branch",
                  //     value: selectedBranch,
                  //     items: branchList,
                  //     onChanged: (val) => setState(() => selectedBranch = val),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),

              // Customer Name
              _buildTextField("Customer Name", _nameController,
                  isRequired: true),
              const SizedBox(height: 16),

              // Customer ID
              _buildTextField("Customer ID", _custIdController,
                  isReadOnly: true),
              const SizedBox(height: 16),

              // Order Advance Type
              _buildDropdown(
                label: "Order Advance",
                value: selectedOdType,
                items: orderAdvList,
                onChanged: (val) => setState(() => selectedOdType = val),
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildTextField(
                "Phone Number",
                _phoneController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length != 10) return 'Invalid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              _buildTextField(
                "Address",
                _addressController,
                isRequired: true,
                maxLines: 3,
              ),

              // Country and Branch selection

              const SizedBox(height: 20),

              // Additional fields checkbox
              Row(
                children: [
                  Checkbox(
                    value: _showAdditionalFields,
                    onChanged: (value) =>
                        setState(() => _showAdditionalFields = value ?? false),
                  ),
                  Text('Show Additional Fields'),
                ],
              ),
              const SizedBox(height: 10),

              // Additional fields (conditionally shown)
              if (_showAdditionalFields) ...[
                _buildTextField("Email", _emailController),
                const SizedBox(height: 16),
                _buildTextField("Place", _placeController),
                const SizedBox(height: 16),
                _buildDateField("Date of Birth"),
                const SizedBox(height: 16),
                _buildTextField("Nominee", _nomineeController),
                const SizedBox(height: 16),
                _buildTextField("Nominee Phone", _nomineePhoneController,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildTextField("Nominee Relation", _nomineeRelationController),
                const SizedBox(height: 16),
                _buildTextField("Aadhar Card", _aadharController),
                const SizedBox(height: 16),
                _buildTextField("PAN Card", _panController),
                const SizedBox(height: 16),
                _buildTextField("PIN Code", _pinCodeController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      children: [
        // Scheme Type
        _buildDropdown(
          label: "Scheme Type",
          value: selectedSchemeType,
          items: schemeTypeList,
          onChanged: (val) => setState(() {
            selectedSchemeType = val;
            _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
          }),
        ),
        const SizedBox(height: 16),

        // Customer Name
        _buildTextField("Customer Name", _nameController, isRequired: true),
        const SizedBox(height: 16),

        // Customer ID
        _buildTextField("Customer ID", _custIdController, isReadOnly: true),
        const SizedBox(height: 16),

        // Order Advance Type
        _buildDropdown(
          label: "Order Advance",
          value: selectedOdType,
          items: orderAdvList,
          onChanged: (val) => setState(() => selectedOdType = val),
        ),
        const SizedBox(height: 16),

        // Phone Number
        _buildTextField(
          "Phone Number",
          _phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (value.length != 10) return 'Invalid phone number';
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Address
        _buildTextField(
          "Address",
          _addressController,
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        // Country and Branch selection
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: "Country",
                value: selectedCountry,
                items: countryList,
                onChanged: (val) => setState(() => selectedCountry = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                label: "Branch",
                value: selectedBranch,
                items: branchList,
                onChanged: (val) => setState(() => selectedBranch = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Additional fields checkbox
        Row(
          children: [
            Checkbox(
              value: _showAdditionalFields,
              onChanged: (value) =>
                  setState(() => _showAdditionalFields = value ?? false),
            ),
            Text('Show Additional Fields'),
          ],
        ),
        const SizedBox(height: 10),

        // Additional fields (conditionally shown)
        if (_showAdditionalFields) ...[
          _buildTextField("Email", _emailController),
          const SizedBox(height: 16),
          _buildTextField("Place", _placeController),
          const SizedBox(height: 16),
          _buildDateField("Date of Birth"),
          const SizedBox(height: 16),
          _buildTextField("Nominee", _nomineeController),
          const SizedBox(height: 16),
          _buildTextField("Nominee Phone", _nomineePhoneController,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField("Nominee Relation", _nomineeRelationController),
          const SizedBox(height: 16),
          _buildTextField("Aadhar Card", _aadharController),
          const SizedBox(height: 16),
          _buildTextField("PAN Card", _panController),
          const SizedBox(height: 16),
          _buildTextField("PIN Code", _pinCodeController,
              keyboardType: TextInputType.number),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          child: Image.asset("assets/images/merladlog_white.png"),
        ),
        SizedBox(height: 10),
        Text(
          "Customer Registration",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: TColo.primaryColor1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    bool isReadOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.edit_outlined, color: TColo.primaryColor1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      validator: validator ??
          (isRequired
              ? (value) => value?.isEmpty ?? true ? 'Required' : null
              : null),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildDateField(String label) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: Icon(Icons.calendar_today, color: TColo.primaryColor1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
            ),
          ),
          controller: TextEditingController(
            text: selectedDate == null
                ? DateFormat('MMM dd, yyyy').format(now)
                : DateFormat('MMM dd, yyyy').format(selectedDate!),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                "Register",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  bool isClick = false;
  bool _isLoading = false;
  Future<void> _submitForm() async {
    if (isClick) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate dropdown selections
    if (selectedSchemeType == null || selectedOdType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both Scheme Type and Order Advance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate country and branch selection
    if (selectedCountry == null || selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both Country and Branch'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save form data
    _formKey.currentState!.save();

    setState(() {
      isClick = true;
      _isLoading = true;
    });

    try {
      // Create user model from form data
      final user = UserModel(
        id: '', // Will be generated by Firestore
        name: _nameController.text,
        custId: _custIdController.text,
        phoneNo: _phoneController.text,
        address: _addressController.text,
        place: _placeController.text,
        mailId: _emailController.text,
        staffId: '', // Will be set based on logged-in staff
        schemeType: selectedSchemeType!,
        balance: 0,
        token: '',
        totalGram: 0,
        branch: selectedBranchObject?.id ?? '',
        branchName: selectedBranch ?? '',
        dateofBirth: selectedDate ?? DateTime.now(),
        nominee: _nomineeController.text,
        nomineePhone: _nomineePhoneController.text,
        nomineeRelation: _nomineeRelationController.text,
        adharCard: _aadharController.text,
        panCard: _panController.text,
        pinCode: _pinCodeController.text,
        staffName: '', // Will be set based on logged-in staff
        tax: 0,
        amc: 0,
        country: selectedCountry ?? '',
      );

      // Get staff info from shared preferences

      // Create customer
      bool? isCreated = await Provider.of<User>(context, listen: false).create(
          user,
          _custIdController.text,
          selectedSchemeType!,
          '',
          '',
          selectedOdType!);

      if (!isCreated!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('you can login after verification complete'),
            backgroundColor: Colors.green,
          ),
        );

        // // Update customer ID counter in Firestore
        // final collection =
        //     FirebaseFirestore.instance.collection("cust_Id_Config");
        // final snapshot = await collection.limit(1).get();

        // if (snapshot.docs.isNotEmpty) {
        //   final docId = snapshot.docs.first.id;
        //   final field =
        //       selectedSchemeType == "Wishlist" ? "altr_config" : "altr_config2";
        //   await collection.doc(docId).update({field: FieldValue.increment(1)});
        // }

        // Close the dialog on success
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer ID already exists!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to create customer: $err'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isClick = false;
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: InputDecoration(
        labelText: "Country",
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: countryList.map((country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) async {
        if (value != null) {
          await _loadBranches(value);
        }
        setState(() {
          selectedCountry = value;
        });
      },
      validator: (value) => value == null ? 'Please select Country' : null,
    );
  }

  Future<void> _generateCustomerId(String schemePrefix) async {
    // In a real app, you would generate this from your backend
    final mockCounter = DateTime.now().millisecondsSinceEpoch % 1000;
    setState(() {
      _custIdController.text = '${schemePrefix}_$mockCounter';
    });
  }

  List<Branch> filteredBranches = [];
  Branch? selectedBranchObject;
  Future<void> _loadBranches(String country) async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    await branchProvider.fetchBranches(country);
    setState(() {
      filteredBranches = branchProvider.branches;
      // Reset selected branch when country changes
      selectedBranch = null;
      selectedBranchObject = null;
    });
  }

  Widget _buildBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      decoration: InputDecoration(
        labelText: "Branch",
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: filteredBranches.map((branch) {
        return DropdownMenuItem<String>(
          value: branch.branchName,
          child: Text(branch.branchName),
          onTap: () {
            selectedBranchObject = branch;
          },
        );
      }).toList(),
      onChanged: (value) => setState(() {
        selectedBranch = value;
      }),
      validator: (value) {
        if (selectedCountry == null) return 'Please select country first';
        if (value == null) return 'Please select Branch';
        return null;
      },
      disabledHint: Text(selectedCountry == null
          ? 'Select country first'
          : filteredBranches.isEmpty
              ? 'No branches available'
              : 'Select branch'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _placeController.dispose();
    _nomineeController.dispose();
    _nomineePhoneController.dispose();
    _nomineeRelationController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _pinCodeController.dispose();
    _custIdController.dispose();
    super.dispose();
  }
}
