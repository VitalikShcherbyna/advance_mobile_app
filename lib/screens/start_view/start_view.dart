import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app/data/user_data.dart';
import 'package:app/models/user_model.dart';
import 'package:app/routes.dart';
import 'package:app/screens/login_view/login_view.dart';
import 'package:app/screens/login_view/widgets/user_already_exist.dart';
import 'package:app/screens/registration_view/registration_view.dart';
import 'package:app/widgets/activity_indicator.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/pop_previous_alert.dart';
import 'package:app/widgets/push_and_clean.dart';

import '../../style_provider.dart';

class StartView extends StatefulWidget {
  StartView({
    Key key,
  }) : super(key: key);

  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  StreamSubscription<UserBase> _authSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(onChangeOrderList);
    SchedulerBinding.instance.addPostFrameCallback(_setUp);
  }

  void onChangeOrderList() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _logOut() async {
    await UserData().signOut();
  }

  void _startLoading() {
    setState(() {
      showActivityDialog(
        context,
        closeButtonText: CustomFlutterI18n.translate(context, 'cancel'),
        showCloseButton: true,
        onClose: _logOut,
        label: CustomFlutterI18n.translate(context, 'LoginView.loading'),
      );
    });
  }

  void _stopLoading() {
    setState(() {
      popPreviosAlert(context);
    });
  }

  void _loginListener(UserBase user) async {
    try {
      if (user != null) {
        if (!(user?.isActive ?? false)) {
          _stopLoading();
          return pushRouteAndClean(context, '/disabledAccount');
        } else if (user.userInfo.displayName == UserRole.MANAGER.toString() ||
            user.userInfo.displayName == UserRole.OWNER.toString()) {
          _stopLoading();
          existUserAlert(context, UserData().signOut);
        } else if (user is UserModel) {
          bool isExist = await UserData().isUserExist();
          if (!isExist) {
            await UserData().createUser();
            await _authSubscription.cancel();
            _stopLoading();
            return pushRouteAndClean(
              context,
              '/user/codeQuestionView',
              arguments: NavigationArguments(
                canSkip: true,
              ),
            );
          }
          await _authSubscription.cancel();
          _stopLoading();
          return pushRouteAndClean(
            context,
            '/user/googleMapsView',
            arguments: NavigationArguments(user: user, canPop: true),
          );
        } else {
          _stopLoading();
          _tryAgain();
        }
      } else {
        _stopLoading();
      }
    } catch (e) {
      _stopLoading();
    }
  }

  void _setUp(Object obj) async {
    try {
      _startLoading();
      _authSubscription = UserData()
          ?.user
          ?.listen(_loginListener, onError: (Object error) => _stopLoading());
    } catch (e) {
      _stopLoading();
    }
  }

  void _tryAgain() {
    showAwesomeAlert(context,
        dialogType: DialogType.WARNING,
        barrierDismissible: false,
        messageText: CustomFlutterI18n.translate(context, 'tryAgain'),
        btnOkOnPress: () async {
      await UserData().signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StylesProvider.of(context).colors.scaffoldBackground,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool value) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Center(
              child: Image.asset(
                "assets/white_logo.png",
                width: 70,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorWeight: 3,
              indicatorColor: StylesProvider.of(context).colors.primaryColor,
              labelStyle: StylesProvider.of(context)
                  .fonts
                  .boldBlue
                  .copyWith(fontSize: 18),
              tabs: [
                Tab(
                  text: CustomFlutterI18n.translate(context, 'LoginView.login'),
                ),
                Tab(
                  text: CustomFlutterI18n.translate(
                      context, 'LoginView.registration'),
                ),
              ],
            ),
            backgroundColor: StylesProvider.of(context).colors.primaryColor,
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            LogInView(),
            RegistrationView(),
          ],
        ),
      ),
    );
  }
}
