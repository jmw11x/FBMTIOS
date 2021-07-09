import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';

String other = '';

class DynamicLV extends StatefulWidget {
  @override
  _DynamicLVState createState() => _DynamicLVState();
}

class _DynamicLVState extends State<DynamicLV> {
  AdminAlert db = new AdminAlert();
  var arr = [];
  String msg = '';
  final controller = ScrollController();
  String cur = '';

  @override
  Widget build(BuildContext context) {
    Future<String> msgs = db.getUsersAsString();
    Future<String> current_user = db.currentuid();
    current_user.then((value) => setState(() {
          cur = value;
        }));
    msgs.then((value) => setState(() {
          msg = value;
        }));
    arr = msg.split('\n');
    // autoadj();
    return ListView.builder(
        reverse: true,
        controller: controller,
        itemCount: arr.length,
        itemBuilder: (context, index) {
          final reversedIndex = arr.length - 1 - index;
          var userid = arr[reversedIndex].split(',')[0];
          // print(userid);

          return InkWell(
            child: new Text(arr[reversedIndex] + "\n\n"),
            onTap: () {
              other = userid;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Conversation()),
              );
              // db.createChat("Open", userid + cur);
            },
          );
        });
  }
}

class DynamicLVC extends StatefulWidget {
  const DynamicLVC({
    Key? key,
  }) : super(key: key);
  @override
  _DynamicLVCState createState() => _DynamicLVCState();
}

class _DynamicLVCState extends State<DynamicLVC> {
  AdminAlert db = new AdminAlert();
  var arr = [];
  String msg = '';
  String cur = '';
  bool chatexists = false;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Future<String> current_user = db.currentuid();
    current_user.then((value) => setState(() {
          cur = value;
        }));
    // print("77" + other + cur);
    // print(other);
    //if(other+cur document exists) getMessagesAsString(other+cur) else below
    Future<bool> exists = db.chatExists(other, cur);
    exists.then((value) => setState(() {
          chatexists = value;
          // print(chatexists);
        }));
    if (chatexists) {
      Future<String> msgs = db.getMessagesAsString(other + cur);
      msgs.then((value) => setState(() {
            msg = value;
            // print(msg);
          }));
    } else {
      Future<String> msgs = db.getMessagesAsString(cur + other);
      msgs.then((value) => setState(() {
            msg = value;
            // print(msg);
          }));
    }

    arr = msg.split('\n');
    // autoadj();
    return ListView.builder(
        reverse: true,
        controller: controller,
        itemCount: arr.length,
        itemBuilder: (context, index) {
          final reversedIndex = arr.length - 1 - index;

          return ListTile(
            title: new Text(arr[reversedIndex]),
          );
        });
  }
}

class Conversation extends StatefulWidget {
  const Conversation({Key? key}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  String message = '';
  String msg = '';
  String current_user = '';
  String name = '';
  String docid = '';

  bool cexists = false;
  bool cexists1 = false;
  var arr = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth1 = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    Future<String> username = db.getUser();

    // msgs.then((value) => setState(() {
    //       msg = value;
    //     }));
    uzr.then((value) => setState(() {
          current_user = value;
        }));
    username.then((value) => setState(() {
          name = value;
        }));

    return Scaffold(
        appBar: AppBar(
          title: Text("Messanger!"),
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: DynamicLVC()),
              Container(
                child: TextFormField(
                  validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                  decoration: InputDecoration(
                      hintText: 'message', helperText: 'chat now'),
                  onChanged: (v) => {setState(() => message = v)},
                ),
              ),
              SingleChildScrollView(
                child: ElevatedButton(
                    onPressed: () async {
                      print(other);
                      print(current_user);
                      //if (other+current) exists add to this thread, else create it
                      Future<bool> exists = db.chatExists(other, current_user);
                      Future<bool> exists1 = db.chatExists(current_user, other);
                      await exists1.then((value) => setState(() {
                            setState(() => cexists1 = value);
                            print(cexists1);
                          }));
                      await exists.then((value) => setState(() {
                            setState(() => cexists = value);
                            print(cexists);
                          }));
                      if (cexists) {
                        print("exists");
                        setState(() => docid = other + current_user);
                      } else if (cexists1) {
                        print('ex1');
                        setState(() => docid = current_user + other);
                      } else {
                        print('not');
                        setState(() => docid = current_user + other);
                      }
                      print(docid);
                      db.addAdminMessage(message, docid, name);

                      FocusScope.of(context).unfocus();
                    },
                    child: Text(">Send")),
              )
            ],
          ),
        ));
  }
}
