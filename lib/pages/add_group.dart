import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/src/provider.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  String? _groupName="";
  ValueNotifier<bool> _usersIsLoaded=ValueNotifier(false);
  List<AppUser>? _users;
  Map<int,String> _selectedUsers={};
  @override
  void initState() {
    super.initState();
    _getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Group"),),
      body: Form(child: Container(
        child: Column(
          children: [
            Container(
              margin:EdgeInsets.all(4) ,
                            padding: EdgeInsets.all(4),
              child: TextFormField(
                decoration: InputDecoration(
                  label: Text("Group Name"),
                  hintText: "My Group",
                ),
                onChanged: (value) {
                  _groupName=value;
                },
                validator: (value) {
                  if(value!.isEmpty) return "Value not Correct";
                },
              ),
            ),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text("Users",textAlign: TextAlign.start,),
                ),
                ValueListenableBuilder(
                  valueListenable:  _usersIsLoaded,
                  builder: (BuildContext context, dynamic value, Widget? child) {
                    if(value){
                      return Container(
                            height: MediaQuery.of(context).size.height*0.35,
                            margin:EdgeInsets.all(8) ,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.blueGrey),
                              borderRadius: BorderRadius.circular(8)
                            ),
                        child: ListView.builder(
                          itemCount: _users?.length??0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                              child: ListTile(
                                tileColor: _selectedUsers.keys.contains(index)?Colors.green.shade300:Colors.blueGrey.shade100,
                                title: Text(_users![index].email!),
                                onTap: (){
                                  if(_selectedUsers.keys.contains(index)) {
                                    _selectedUsers.remove(index);
                                  } else {
                                    _selectedUsers.addAll({index:_users![index].userId!});
                                  }
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return  Container( height: 100,child: Center(child: CircularProgressIndicator(),));
                  },
                ),
              ],
            ),
            ElevatedButton(onPressed: _saveGroup, child: Text("Save"))
          ],
        ),
      ),),
    );
  }
  _saveGroup()async{
    if(_groupName==null || _groupName!.isEmpty) return;
    final _userModel=context.read<UserModel>();
    print (_userModel.getCurrentUser());
    final _transaction=context.read<MTransaction>();
    await _transaction.saveGroup(Group.init(groupId: Random().nextInt(9999999).toString(), groupName: _groupName,groupUsers: [_userModel.getCurrentUser()!.userId!,..._selectedUsers.values],groupAdmin:_userModel.getCurrentUser()!.userId! ));
    Navigator.of(context).pop();
  }
  _getUsers()async{
    _usersIsLoaded.value=false;
    final _transaction=context.read<MTransaction>();
    _users=await _transaction.getUsers();
    _usersIsLoaded.value=true;
  }
}