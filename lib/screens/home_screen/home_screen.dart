import 'package:flutter/material.dart';
import 'package:flutter_otp_module/bagel_db.dart';

import '../login_screen/widget/custom_delete_user_btn.dart';

Future<void> clickOnDeleteUser(BuildContext context) async {
  try {
    await db.bagelUsersRequest.deleteUser();
    print({'res': 'User deleted'});
    final responseMessage = await Navigator.pushNamed(context, '/#/');
    print({'responseMessage': responseMessage});
  } catch (e) {
    print({e});
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(16.0)),
            child: const Column(
              children: [
                Text(
                  'Phone Verification successful!',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 50,
                  child: Text(
                    'To delete your account and logout, click on the button below',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                CustomButton(clickOnDeleteUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
