import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // إضافة حرف إلى قائمة الحروف المكتملة مع حماية عدم التخطى
  static Future<void> addCompletedLetter(int letterIndex) async {
    final user = _auth.currentUser;
    if (user != null && letterIndex >= 0 && letterIndex < 28) {
      // جلب الحروف المكتملة الحالية
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      List<dynamic> completed = [];
      if (data != null && data.containsKey('completedLetters')) {
        completed = List<dynamic>.from(data['completedLetters']);
      }
      if (completed.length < 29 && !completed.contains(letterIndex)) {
        await _firestore.collection('users').doc(user.uid).update({
          'completedLetters': FieldValue.arrayUnion([letterIndex]),
        });
      }
    }
  }


  // الحصول على الحروف المكتملة
  static Future<List<int>> getCompletedLetters() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final data = doc.data();
        if (data != null && data.containsKey('completedLetters')) {
          return List<int>.from(data['completedLetters']);
        } else {
          // If the field doesn't exist, create it with an empty array
          await _firestore.collection('users').doc(user.uid).set({
            'completedLetters': [],
          }, SetOptions(merge: true));
          return [];
        }
      } catch (e) {
        print('Error getting completed letters: $e');
        return [];
      }
    }
    return [];
  }

  // الحصول على الأرقام المكتملة
  static Future<List<int>> getCompletedNumbers() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final data = doc.data();
        if (data != null && data.containsKey('completedNumbers')) {
          return List<int>.from(data['completedNumbers']);
        } else {
          // If the field doesn't exist, create it with an empty array
          await _firestore.collection('users').doc(user.uid).set({
            'completedNumbers': [],
          }, SetOptions(merge: true));
          return [];
        }
      } catch (e) {
        print('Error getting completed numbers: $e');
        return [];
      }
    }
    return [];
  }
}
