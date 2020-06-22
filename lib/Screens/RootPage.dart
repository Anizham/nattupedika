import 'package:flutter/material.dart';
import 'package:nattupedika/user.dart';
import 'package:provider/provider.dart';

import '../Authentication/UserType.dart';
import 'CustomerHome.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return UserType();
    } else {
        return CustomerHomePage(user: user,);
    }
  }
}
