import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/add_group.dart';
import 'package:flutter_sandik/pages/transactions_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage(this.user, {Key? key}) : super(key: key);

  final AppUser? user;
  List<Group>? _groups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sandix"),
          actions: [
            IconButton(onPressed: () async=>_signOut(context), icon: Icon(Icons.exit_to_app)),
            IconButton(onPressed: () =>_createGroup(context), icon: Icon(Icons.group_add)),
          ],
        ),
        body: FutureBuilder(
          future: _getGroups(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_groups == null || _groups?.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      Text("Your Not Subscribed In Any Group"),
                      ElevatedButton(
                          onPressed: () =>_createGroup(context), child: Text("Create Group"))
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: _groups!.length,
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.orange,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  TransactionsPage(_groups![index].groupId!)));
                      },
                      title: Text(_groups![index].groupName ?? ""),
                    )),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  _signOut(BuildContext context) async {
    final _userModel = context.read<UserModel>();
    await _userModel.signOut();
  }

  _getGroups(BuildContext context) async {
    final _transaction = context.read<MTransaction>();
    _groups = [];
    _groups = await _transaction.getGroups(user!.userId!);
  }

  void _createGroup(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddGroup(),
    ));
  }
}
