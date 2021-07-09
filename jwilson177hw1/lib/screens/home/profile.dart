import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';

class EmailFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? 'cannot email leave empty' : null;
  }
}

class PWFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? 'cannot PW leave empty' : null;
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid = '';
  String firstName = '';
  String social = "";
  String lastName = '';
  String email = '';
  String pw = '';
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    uzr.then((value) => setState(() {
          uid = value;
        }));

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (v) => EmailFieldValidator.validate(v!),
                decoration: InputDecoration(
                    hintText: 'firstname', helperText: 'Change first name'),
                onChanged: (v) => {setState(() => firstName = v)},
              ),
              TextFormField(
                validator: (v) => EmailFieldValidator.validate(v!),
                decoration: InputDecoration(
                    hintText: 'last name', helperText: 'reset last name'),
                onChanged: (v) => {setState(() => lastName = v)},
              ),
              TextFormField(
                validator: (v) => EmailFieldValidator.validate(v!),
                decoration: InputDecoration(
                    hintText: 'email', helperText: 'login email'),
                onChanged: (v) => {setState(() => email = v)},
              ),
              TextFormField(
                validator: (v) => PWFieldValidator.validate(v!),
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password', helperText: '6 char + pw'),
                onChanged: (v) => {setState(() => pw = v)},
              ),
              ElevatedButton(
                  child: Text('Reset Name'),
                  onPressed: () async {
                    await db.updateProfile(firstName, lastName, email, pw);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
