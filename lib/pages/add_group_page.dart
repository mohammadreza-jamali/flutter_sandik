import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

class AddGroupPage extends StatefulWidget{
     final Group group;

  const AddGroupPage({super.key, required this.group});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {

 TextEditingController searchController=TextEditingController();
  String? _groupName = "";
  late Group _group;
  ValueNotifier<bool> _usersIsLoaded = ValueNotifier(false);
  List<AppUser>? _users;
  List<AppUser> _selectedUsers = [];

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
    final List<IconData> icons=MdiIcons.getIcons();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text('Add Group',style: TextStyle(color: Color(0xff16398B)),),
          iconTheme: IconThemeData(
            color: Color(0xff16398B)
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    label: Text('Gruop Name',),
                  ),
                ),
              ),

              SizedBox(height: 4,),
              Directionality(
                textDirection: TextDirection.rtl,
                child: 
                DropdownSearch<AppUser>.multiSelection(
                  
                  selectedItems: _selectedUsers,
                  itemAsString: (item) => item.email??"",
    asyncItems: (String filter) async {
      print(filter);
       return getUsersByFilter(filter);
    },
    compareFn: (item, selectedItem) => item.userId == selectedItem.userId,
     dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "BottomSheet mode",
                          hintText: "Select an Int",
                        ),
                      ),
                      popupProps: PopupPropsMultiSelection.bottomSheet(
                        showSearchBox: true,
                        showSelectedItems: true,
                        searchFieldProps: TextFieldProps(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(MdiIcons.magnify),
                            label: Text('Users'),
                            hintText: 'search user email',
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                          bottomSheetProps: BottomSheetProps(elevation: 16, backgroundColor: Colors.grey.shade50,), 
                          ),
                          
    onChanged: (List<AppUser>? data) {
      // _selectedUsers=[];
      // for (var user in data??[]) {
      //   if(_selectedUsers.any((selectedUser)=>user.userId==selectedUser.userId))
      //   continue;

      //   _selectedUsers.add(user);
      // }
      
      // setState((){});
    },
)
                // ValueListenableBuilder(
                //       valueListenable: _usersIsLoaded,
                //       builder:
                //           (BuildContext context, dynamic value, Widget? child) {
                //         if (value) {
                //           // return Container(
                //           //   height: MediaQuery.of(context).size.height * 0.35,
                //           //   margin: EdgeInsets.all(8),
                //           //   padding: EdgeInsets.all(8),
                //           //   decoration: BoxDecoration(
                //           //       border: Border.all(color: Colors.blueGrey),
                //           //       borderRadius: BorderRadius.circular(8)),
                //           //   child: ListView.builder(
                //           //     itemCount: _users?.length ?? 0,
                //           //     itemBuilder: (BuildContext context, int index) {
                //           //       var _userId = _users![index].userId;
                //           //       return Container(
                //           //         margin: EdgeInsets.symmetric(
                //           //             vertical: 4, horizontal: 4),
                //           //         child: ListTile(
                //           //           leading: Icon(Icons.person_pin),
                //           //           shape: RoundedRectangleBorder(
                //           //               borderRadius: BorderRadius.circular(4),
                //           //               side: BorderSide(
                //           //                   width: 2,
                //           //                   color:
                //           //                       _selectedUsers.contains(_userId)
                //           //                           ? Colors.green.shade400
                //           //                           : Colors.red.shade400)),
                //           //           tileColor:
                //           //               Theme.of(context).colorScheme.surface,
                //           //           title: Text(_users![index].email!),
                //           //           onTap: () {
                //           //             if (_selectedUsers.contains(_userId)) {
                //           //               _selectedUsers.remove(_userId);
                //           //             } else {
                //           //               _selectedUsers.add(_userId!);
                //           //             }
                //           //             if(mounted) setState(() {});
                //           //           },
                //           //         ),
                //           //       );
                //           //     },
                //           //   ),
                //           // );
                          
                //         }
                //         return Container(
                //             height: 100,
                //             child: Center(
                //               child: CircularProgressIndicator(),
                //             ));
                //       },
                //     ),
              ),
              ElevatedButton(onPressed: ()=>_addGroupMemberBottomSheet(context,_users), child: Text('add users')),
              SizedBox(height: 32,),
              ElevatedButton(onPressed: _saveGroup, child: Text('ُSAVE',style: TextStyle(color:Color(0xff16398B) ),),style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(150, 50)),
                backgroundColor: WidgetStateProperty.all(Colors.indigo.shade50)
              ),),
            ],
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
        groupId: Uuid().v8(),
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
        _selectedUsers.add(user);
      }
    });
    if(mounted)
    {
      setState(() {
        
      });
    }
  }

 Future<List<AppUser>> getUsersByFilter(String filter)async{
     final _transaction = context.read<MTransaction>();
        var users=await  _transaction.getUsers();
        return users??[];
  }
}

Future _addGroupMemberBottomSheet(BuildContext context, List<AppUser>? users){
 return showModalBottomSheet(context: context, builder: (context){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 400,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: MediaQuery.of(context).size.width,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: Icon(MdiIcons.magnify,color: Colors.grey,),
              hintText: 'search',
            ),
          ),
        ),

        Expanded(
          child: GroupMembersList(users: users),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
          child: ElevatedButton(onPressed: (){}, child: Text('ok')),
        ),
      ],
    ),
  );
 });
}

class GroupMembersList extends StatelessWidget {
  final List<AppUser>? users;
  const GroupMembersList({
    super.key, required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return GroupMembersListItem(users: users);
  }
}

class GroupMembersListItem extends StatefulWidget {
  const GroupMembersListItem({
    super.key,
    required this.users,
  });

  final List<AppUser>? users;

  @override
  State<GroupMembersListItem> createState() => _GroupMembersListItemState();
}

class _GroupMembersListItemState extends State<GroupMembersListItem> {
  @override
  Widget build(BuildContext context) {
      bool? isCheked = false;
    return ListView.builder(
      itemCount: widget.users!.length,
      itemBuilder: (BuildContext context,index){
      return Container(
        padding: EdgeInsets.fromLTRB(12,8,12,0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
    
        child: Row(
          children: [
            Icon(MdiIcons.account),
            SizedBox(width: 8,),
            Expanded(child: Text(widget.users![index].email!)),
            Checkbox(
              tristate: true,
              value: isCheked, onChanged: (bool? value){
              setState(() {
                isCheked = value;
              });
            }),
          ],
        ),
      );
    });
  }
}

