import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/src/provider.dart';

class AddGroup extends StatefulWidget {
  const AddGroup(this.group, {Key? key}) : super(key: key);
  final Group group;
  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  String? _groupName = "";
  late Group _group;
  ValueNotifier<bool> _usersIsLoaded = ValueNotifier(false);
  List<AppUser>? _users;
  List<String> _selectedUsers = [];

  late TextEditingController _groupNameController;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _groupNameController = TextEditingController()
      ..text = _group.groupName ?? "";
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("${_group.groupId == null ? "Add" : "Edit"} Group"),
      ),
      body: Card(
        child: Form(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.all(4),
                  child: TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      label: Text("Group Name"),
                      hintText: "Enter group name",
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Entered group name is not valid";
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Users",
                        textAlign: TextAlign.start,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _usersIsLoaded,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        if (value) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(8)),
                            child: ListView.builder(
                              itemCount: _users?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                var _userId = _users![index].userId;
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 4),
                                  child: ListTile(
                                    leading: Icon(Icons.person_pin),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            width: 2,
                                            color:
                                                _selectedUsers.contains(_userId)
                                                    ? Colors.green.shade400
                                                    : Colors.red.shade400)),
                                    tileColor:
                                        Theme.of(context).colorScheme.background,
                                    title: Text(_users![index].email!),
                                    onTap: () {
                                      if (_selectedUsers.contains(_userId)) {
                                        _selectedUsers.remove(_userId);
                                      } else {
                                        _selectedUsers.add(_userId!);
                                      }
                                      if(mounted) setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: _saveGroup,
                    child: Text(
                      "Save",
                      style: Theme.of(context).textTheme.displayLarge,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveGroup() async {
    if ( _groupNameController.text.isEmpty) return;
    final _userModel = context.read<UserModel>();
    _group.groupId==null?await _addNewGroup(_userModel):await _editGroup(_userModel);
    Navigator.of(context).pop();
  }

  _addNewGroup(UserModel userModel) async {
    final _transaction = context.read<MTransaction>();
    await _transaction.saveGroup(Group.init(
        groupId: Random().nextInt(9999999).toString(),
        groupName: _groupNameController.text,
        groupUsers: [userModel.getCurrentUser()!.userId!, ..._selectedUsers],
        groupAdmin: userModel.getCurrentUser()!.userId!));
  }

  _editGroup(UserModel userModel) async {
    final _transaction = context.read<MTransaction>();
    _group.groupName = _groupNameController.text;
    _group.groupUsers = [
      userModel.getCurrentUser()!.userId!,
      ..._selectedUsers
    ];
    await _transaction.updateGroup(_group);
  }

  _getUsers() async {
    _usersIsLoaded.value = false;
    final _transaction = context.read<MTransaction>();
    _users = await _transaction.getUsers();
    _usersIsLoaded.value = true;
    _selectedUsers = [];
    _users?.forEach((user) {
      if (_group.groupUsers?.any((groupUser) => groupUser == user.userId) ??
          false) {
        _selectedUsers.add(user.userId!);
      }
    });
  }
}
