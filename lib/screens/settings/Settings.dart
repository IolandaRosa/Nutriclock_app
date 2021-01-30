import 'package:flutter/material.dart';
import 'package:nutriclock_app/screens/settings/ChangeEmail.dart';
import 'package:nutriclock_app/screens/settings/ChangePassword.dart';
import 'package:nutriclock_app/screens/settings/Profile.dart';

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Definições",
            style: TextStyle(
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Color(0xFFA3E1CB),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                color: Color(0xFF60B2A3),
              ),
              title: Text(
                "Perfil",
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontFamily: 'Roboto',
                ),
              ),
              trailing:
                  Icon(Icons.keyboard_arrow_right, color: Color(0xFF60B2A3)),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Color(0xFF60B2A3)),
              title: Text(
                "Alterar Password",
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontFamily: 'Roboto',
                ),
              ),
              trailing:
                  Icon(Icons.keyboard_arrow_right, color: Color(0xFF60B2A3)),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFF60B2A3)),
              title: Text(
                "Alterar Email",
                style: TextStyle(
                  color: Color(0xFF60B2A3),
                  fontFamily: 'Roboto',
                ),
              ),
              trailing:
                  Icon(Icons.keyboard_arrow_right, color: Color(0xFF60B2A3)),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
            )
          ],
        ));
  }
}
