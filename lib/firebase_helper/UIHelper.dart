import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: EdgeInsets.all(3.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 3.h,),
            Text(title)
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlertDialog(BuildContext context, String title, String content){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Ok')
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_){
          return alertDialog;
        }
    );
  }

}
