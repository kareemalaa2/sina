import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LoginAlert extends StatelessWidget {
  const LoginAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.all(3),
          title: const Icon(Icons.login_outlined,size: 35,),
          contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12.0,),
          content: Text(S.current.signInMsg,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,),),
          actionsPadding: const EdgeInsets.all(3),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(S.current.cancel,style: const TextStyle(fontWeight: FontWeight.bold,),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(S.current.signIn,style: const TextStyle(fontWeight: FontWeight.bold,),),
            ),
          ],
        );
  }
}