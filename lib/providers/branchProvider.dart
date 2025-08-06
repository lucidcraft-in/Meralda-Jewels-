import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/branchModel.dart';

class BranchProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Branch> _branches = [];
  bool _isLoading = false;

  List<Branch> get branches => _branches;
  bool get isLoading => _isLoading;

  Future<void> fetchBranches(String branchLocation) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('branches')
          .where("branchLocation", isEqualTo: branchLocation)
          .get();
      _branches = snapshot.docs
          .map((doc) => Branch.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching branches: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBranch(Branch branch) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('branches').add(branch.toMap());
      await fetchBranches(branch.branchLocation);
    } catch (e) {
      debugPrint('Error adding branch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBranch(Branch branch) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('branches')
          .doc(branch.id)
          .update(branch.toMap());
      await fetchBranches(branch.branchLocation);
    } catch (e) {
      debugPrint('Error updating branch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBranch(String branchId, String branchLocation) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('branches').doc(branchId).delete();
      await fetchBranches(branchLocation);
    } catch (e) {
      debugPrint('Error deleting branch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>> getStaffInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'staffId': prefs.getString('staffId') ?? '',
      'staffName': prefs.getString('staffName') ?? '',
    };
  }
}
