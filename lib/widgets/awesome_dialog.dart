import 'package:awesome_dialog/animated_button.dart';
import 'package:awesome_dialog/anims/anims.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/flare_header_animation.dart';
import 'package:app/widgets/vertical_stack_dialog.dart';

class CustomAwesomeDialog {
  final DialogType dialogType;
  final Widget customHeader;
  final String tittle;
  final String desc;
  final BuildContext context;
  final String btnOkText;
  final IconData btnOkIcon;
  final Function btnOkOnPress;
  final Color btnOkColor;
  final String btnCancelText;
  final IconData btnCancelIcon;
  final Function btnCancelOnPress;
  final Color btnCancelColor;
  final Widget btnOk;
  final Widget btnCancel;
  final Widget body;
  final bool dismissOnTouchOutside;
  final Function onDissmissCallback;
  final AnimType animType;
  CustomAwesomeDialog(
      {@required this.context,
      this.dialogType,
      this.customHeader,
      this.tittle,
      this.desc,
      this.body,
      this.btnOk,
      this.btnCancel,
      this.btnOkText,
      this.btnOkIcon,
      this.btnOkOnPress,
      this.btnOkColor,
      this.btnCancelText,
      this.btnCancelIcon,
      this.btnCancelOnPress,
      this.btnCancelColor,
      this.onDissmissCallback,
      this.dismissOnTouchOutside = true,
      this.animType = AnimType.SCALE})
      : assert(
          dialogType != null || customHeader != null,
          context != null,
        );

  Future show() {
    return showDialog<void>(
        context: this.context,
        barrierDismissible: dismissOnTouchOutside,
        builder: (BuildContext context) {
          switch (animType) {
            case AnimType.SCALE:
              return Scale(
                  scalebegin: 0.1,
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: _buildDialog());
              break;
            case AnimType.LEFTSLIDE:
              return Slide(from: SlideFrom.LEFT, child: _buildDialog());
              break;
            case AnimType.RIGHSLIDE:
              return Slide(from: SlideFrom.RIGHT, child: _buildDialog());
              break;
            case AnimType.BOTTOMSLIDE:
              return Slide(from: SlideFrom.BOTTOM, child: _buildDialog());
              break;
            case AnimType.TOPSLIDE:
              return Slide(from: SlideFrom.TOP, child: _buildDialog());
              break;
            default:
              return _buildDialog();
          }
        }).then<void>((_) {
      if (onDissmissCallback != null) onDissmissCallback();
    });
  }

  Widget _buildDialog() {
    return CustomVerticalStackDialog(
      header: customHeader ??
          CustomFlareHeader(
            dialogType: dialogType,
          ),
      title: this.tittle,
      desc: this.desc,
      body: this.body,
      btnOk: btnOk ?? (btnOkOnPress != null ? _buildFancyButtonOk() : null),
      btnCancel: btnCancel ??
          (btnCancelOnPress != null ? _buildFancyButtonCancel() : null),
    );
  }

  Widget _buildFancyButtonOk() {
    return AnimatedButton(
      pressEvent: () {
        Navigator.of(context).pop();
        btnOkOnPress();
      },
      text: btnOkText ?? 'Ok',
      color: btnOkColor ?? Color(0xFF00CA71),
      icon: btnOkIcon,
    );
  }

  Widget _buildFancyButtonCancel() {
    return AnimatedButton(
      pressEvent: () {
        Navigator.of(context).pop();
        btnCancelOnPress();
      },
      text: btnCancelText ?? 'Cancel',
      color: btnCancelColor ?? Colors.red,
      icon: btnCancelIcon,
    );
  }

  void dissmiss() {
    Navigator.of(context).pop();
  }
}
