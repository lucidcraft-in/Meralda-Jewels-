import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';

class UserRegistrationDialog extends StatefulWidget {
  @override
  State<UserRegistrationDialog> createState() => _UserRegistrationDialogState();
}

class _UserRegistrationDialogState extends State<UserRegistrationDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _placeController = TextEditingController();
  final _emailController = TextEditingController();
  final _extraController = TextEditingController();

  String? selectedScheme;
  String? selectedBranch;

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
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField("Name", _nameController),
                            _buildTextField("Phone Number", _phoneController),
                            _buildTextField(
                                "WhatsApp Number", _whatsappController),
                            _buildTextField("Address", _addressController),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField("Place", _placeController),
                            _buildTextField("Email ID", _emailController),
                            _buildDropdown(
                              label: "Select Scheme Type",
                              items: ["Monthly", "Weekly", "Lump sum"],
                              onChanged: (val) => selectedScheme = val,
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown(
                              label: "Select Branch",
                              items: ["Branch A", "Branch B", "Branch C"],
                              onChanged: (val) => selectedBranch = val,
                            ),
                            // const SizedBox(height: 16),
                            // _buildTextField("Extra Field", _extraController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRegisterButton(),
                ],
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
          "User Registration",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: TColo.primaryColor1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
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
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
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
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registered successfully!"),
              backgroundColor: TColo.primaryColor1,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Register",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _placeController.dispose();
    _emailController.dispose();
    _extraController.dispose();
    super.dispose();
  }
}
