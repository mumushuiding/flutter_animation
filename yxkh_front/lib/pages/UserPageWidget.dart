import 'package:flutter/material.dart';
import 'package:yxkh_front/api/user_api.dart';
import 'package:yxkh_front/pages/dashboard.dart';
import 'package:yxkh_front/pages/user/changePassword.dart';

import '../app.dart';

class UserPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangePasswordWidget(
      onChange: (oldpass, newpass) {
        UserAPI.alterPassword(oldpass, newpass).then((data) {
          if (data["status"] != 200) {
            App.showAlertError(context, data["message"]);
            return;
          }
          App.logOut();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return DashboardWidget();
            },
          ));
        });
      },
    );
  }
}
