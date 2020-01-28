import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseAuth {
  Stream<UserBase> get user;
  Future<FirebaseUser> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<FirebaseUser> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<void> signOut();
}

class UserData implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static BehaviorSubject<UserBase> _user;

  @override
  Stream<UserBase> get user {
    if (_user == null) {
      _user = BehaviorSubject<UserBase>();
      _fetchUser().listen((UserBase user) {
        _user.add(user);
      });
    }
    return _user.stream;
  }

  ///SIGN IN `USER`
  @override
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
  }

  Future<String> signInWithGmail(VoidCallback startLoading) async {
    GoogleSignInAccount googleSignIn =
        await GoogleSignIn(scopes: ['email']).signIn();
    if (googleSignIn != null) {
      startLoading();
      GoogleSignInAuthentication auth = await googleSignIn.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: auth?.idToken,
        accessToken: auth?.accessToken,
      );

      return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
    }
    return null;
  }

  Future<String> signInWithFaceBook(
      VoidCallback startLoading, VoidCallback cancel) async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        startLoading();
        AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
        break;
      case FacebookLoginStatus.cancelledByUser:
        cancel();
        return null;
      case FacebookLoginStatus.error:
        throw PlatformException(
            message: result.errorMessage, code: result.errorMessage);
        break;
      default:
        return null;
    }
  }

  ///CREATE `USER` ACCOUNT
  @override
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult firebaseUser =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return firebaseUser?.user;
  }

  Future<bool> isUserExist() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();
    return userDoc.exists;
  }

  Future<void> createUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    bool isExist = await isUserExist();
    if (isExist) return null;
    WriteBatch batch = Firestore.instance.batch();
    UserModel user = UserModel.fromMap(null, firebaseUser);
    user.isActive = true;
    user.email = user.userInfo?.email;
    user.userRole = UserRole.CUSTOMER;
    await user.userInfo.updateProfile(
        UserUpdateInfo()..displayName = UserRole.CUSTOMER.toString());

    batch.setData(
      await Firestore.instance.collection('users').document(user.userInfo.uid),
      user.toMap(),
    );

    await batch.commit();
  }

  Future<void> updateUserName(String displayName) async {
    WriteBatch batch = Firestore.instance.batch();
    UserModel user = _user.value;
    user.displayName = displayName;

    batch.updateData(
      await Firestore.instance.collection('users').document(user.userInfo.uid),
      <String, dynamic>{"displayName": displayName},
    );

    await batch.commit();
  }

  Future<void> updateUserPhone(String phone) async {
    WriteBatch batch = Firestore.instance.batch();
    UserModel user = _user.value;
    user.phone = phone;

    batch.updateData(
      await Firestore.instance.collection('users').document(user.userInfo.uid),
      <String, dynamic>{"phone": phone},
    );

    await batch.commit();
  }

  Future<UserBase> _getUser(FirebaseUser user, {bool isRefresh = false}) async {
    DocumentSnapshot userDoc =
        await Firestore.instance.collection('users').document(user.uid).get();

    return await UserModel.fromMap(userDoc.data, user);
  }

  Future<void> setNotificationToken(
      {String token, @required bool isCustomer}) async {
    WriteBatch batch = Firestore.instance.batch();
    UserBase user = _user.value;
    user.notificationToken = token;

    batch.updateData(
      await Firestore.instance
          .collection(isCustomer ? 'users' : 'delivers')
          .document(user.userInfo.uid),
      <String, dynamic>{
        'notificationToken': token,
      },
    );

    await batch.commit();
  }

  Future<void> setEmail() async {
    WriteBatch batch = Firestore.instance.batch();
    UserModel user = _user.value;
    user.email = user.userInfo?.email;

    batch.updateData(
      await Firestore.instance.collection('users').document(user.userInfo.uid),
      <String, dynamic>{
        'email': user.userInfo?.email,
      },
    );

    await batch.commit();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<UserBase> _fetchUser() {
    return _firebaseAuth.onAuthStateChanged.asyncMap(
      (FirebaseUser user) async {
        try {
          if (user != null) {
            return await _getUser(user);
          }
        } catch (e) {}
        return null;
      },
    );
  }

  Future<UserBase> refetchUser() async {
    FirebaseUser userInfo = await _firebaseAuth.currentUser();
    UserBase user = await _getUser(userInfo, isRefresh: true);
    _user.add(user);
    return user;
  }
}
