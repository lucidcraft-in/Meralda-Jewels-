import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart';
import 'widgets/webLogout.dart';

class Webprofile extends StatefulWidget {
  const Webprofile({Key? key}) : super(key: key);

  @override
  State<Webprofile> createState() => _WebprofileState();
}

class _WebprofileState extends State<Webprofile> {
  Map<String, dynamic>? localUserData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLocally();
  }

  Future<void> _loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("user")) {
      var userJson = pref.getString("user");
      if (userJson != null) {
        setState(() {
          localUserData = json.decode(userJson);
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    color: TColo.primaryColor1,
                    child: Center(
                      child: Text(
                        'Customer Profile',
                        style: TextStyle(
                          color: TColo.primaryColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileHeader(),
                  const SizedBox(height: 30),
                  _buildDataSourceIndicator(),
                  const SizedBox(height: 20),
                  LogoutButton(
                    onLogoutSuccess: () {
                      // Navigate to login screen or perform other actions
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebHomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildProfileSection(),
                  const SizedBox(height: 30),
                  _buildNomineeSection(),
                  const SizedBox(height: 30),
                  _buildDocumentSection(),
                  if (localUserData != null) _buildLocalDataSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildDataSourceIndicator() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            localUserData != null
                ? "Showing data from API with local backup"
                : "Showing data from API only",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final displayData = localUserData;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: TColo.primaryColor1.withOpacity(0.2),
          child: Icon(
            Icons.person,
            size: 50,
            color: TColo.primaryColor1,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          displayData!['name'] ?? 'No Name',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: TColo.primaryColor1,
          ),
        ),
        Text(
          'ID: ${displayData!['custId'] ?? 'N/A'}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        if (localUserData != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '(Local copy)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileSection() {
    final displayData = localUserData;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            const Divider(),
            _buildInfoRowWithSource('Phone', displayData!['phoneNo']),
            _buildInfoRowWithSource('Address', displayData['address']),
            _buildInfoRowWithSource('Place', displayData['place']),
            _buildInfoRowWithSource('Branch', displayData['branch']),
            _buildInfoRowWithSource('Scheme Type', displayData['schemeType']),
            _buildInfoRowWithSource('Balance',
                '₹${displayData!['balance']?.toStringAsFixed(2) ?? '0.00'}'),
            _buildInfoRowWithSource('Total Gold',
                '${displayData['totalGram']?.toStringAsFixed(2) ?? '0.00'} g'),
          ],
        ),
      ),
    );
  }

  Widget _buildNomineeSection() {
    final displayData = localUserData;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Nominee Details'),
            const Divider(),
            _buildInfoRowWithSource('Nominee Name', displayData!['nominee']),
            _buildInfoRowWithSource(
                'Nominee Phone', displayData['nomineePhone']),
            _buildInfoRowWithSource('Relation', displayData['nomineeRelation']),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSection() {
    final displayData = localUserData;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Document Details'),
            const Divider(),
            _buildInfoRowWithSource('Aadhar Number', displayData!['adharCard']),
            _buildInfoRowWithSource('PAN Number', displayData['panCard']),
            _buildInfoRowWithSource('PIN Code', displayData['pinCode']),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalDataSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Local Storage Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow(
                'Last Updated', _formatDate(localUserData!['timestamp'])),
            _buildInfoRow('Storage Key', 'user'),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return DateFormat('dd MMM yyyy HH:mm').format(timestamp.toDate());
      }
      return 'Unknown';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildInfoRowWithSource(String label, String? value) {
    final isLocal = localUserData != null &&
        localUserData!.containsKey(label.toLowerCase().replaceAll(' ', ''));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Not provided',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isLocal)
                  Icon(Icons.phone_android, size: 16, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: TColo.primaryColor1,
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
