import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

class AddGroupPage extends StatefulWidget {
  final Group group;

  const AddGroupPage({super.key, required this.group});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  TextEditingController searchController = TextEditingController();
  late Group _group;
  ValueNotifier<bool> _usersIsLoaded = ValueNotifier(false);
  List<AppUser>? _users;
  List<AppUser> _selectedUsers = [];

  late TextEditingController _groupNameController;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _groupNameController = TextEditingController()..text = _group.groupName ?? "";
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff050119),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff050119),
          toolbarHeight: 80,
          title: Text(
            'Add Group',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    label: Text(
                      'Gruop Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownSearch<AppUser>.multiSelection(
                    selectedItems: _selectedUsers,
                    itemAsString: (item) => item.email ?? "",
                    asyncItems: (String filter) async {
                      print(filter);
                      return getUsersByFilter(filter);
                    },
                    compareFn: (item, selectedItem) => item.userId == selectedItem.userId,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Group Users",
                        hintText: "Select your group users",
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
                      bottomSheetProps: BottomSheetProps(
                        elevation: 16,
                        backgroundColor: Color(0xff03001C),
                      ),
                    ),
                  )),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     ElevatedButton(onPressed: () => _addGroupMemberBottomSheet(context, _users), child: Text('add users',style: TextStyle(color: Color(0xff16398B)),)),
              //   ],
              // ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: _saveGroup,
                    child: Text(
                      'ُSAVE',
                      style: TextStyle(color: Colors.blue.shade200),
                    ),
                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(Color(0xff050119)),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        side: WidgetStatePropertyAll(BorderSide(color: Colors.blue.shade200, width: 2))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _saveGroup() async {
    if (_groupNameController.text.isEmpty) return;
    final _userModel = context.read<UserModel>();
    _group.groupId == null ? await _addNewGroup(_userModel) : await _editGroup(_userModel);
    Navigator.of(context).pop();
  }

  _addNewGroup(UserModel userModel) async {
    final _transaction = context.read<MTransaction>();
    var groupId = Uuid().v8();
    await _transaction.saveGroup(Group.init(
        groupId: groupId,
        groupName: _groupNameController.text,
        groupUsers: [userModel.getCurrentUser()!.userId!, ..._selectedUsers],
        groupAdmin: userModel.getCurrentUser()!.userId!));

    await _transaction.initDefaultCategories([
      Category.init(groupId: groupId, categoryId: Uuid().v8(), categoryName: "غدا و خوراک", icon: "food", isDefault: true),
      Category.init(groupId: groupId, categoryId: Uuid().v8(), categoryName: "لباس و پوشاک", icon: "tshirtCrew", isDefault: true),
      Category.init(groupId: groupId, categoryId: Uuid().v8(), categoryName: "حمل و نقل", icon: "carSide", isDefault: true),
      Category.init(groupId: groupId, categoryId: Uuid().v8(), categoryName: "قبض موبایل", icon: "cellphone", isDefault: true),
    ]);
  }

  _editGroup(UserModel userModel) async {
    final _transaction = context.read<MTransaction>();
    _group.groupName = _groupNameController.text;
    _group.groupUsers = [userModel.getCurrentUser()!.userId!, ..._selectedUsers];
    await _transaction.updateGroup(_group);
  }

  _getUsers() async {
    _usersIsLoaded.value = false;
    final _transaction = context.read<MTransaction>();
    _users = await _transaction.getUsers();
    _usersIsLoaded.value = true;
    _selectedUsers = [];
    _users?.forEach((user) {
      if (_group.groupUsers?.any((groupUser) => groupUser == user.userId) ?? false) {
        _selectedUsers.add(user);
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<AppUser>> getUsersByFilter(String filter) async {
    final _transaction = context.read<MTransaction>();
    var users = await _transaction.getUsers();
    return users ?? [];
  }
}

Future _addGroupMemberBottomSheet(BuildContext context, List<AppUser>? users) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          color: Color(0xff03001C),
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
                    prefixIcon: Icon(
                      MdiIcons.magnify,
                      color: Colors.grey,
                    ),
                    hintText: 'search',
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Color(0xff16398B),
                ),
              ),
              Expanded(
                child: GroupMembersList(users: users),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: ElevatedButton(onPressed: () {}, child: Text('ok',style: TextStyle(color: Color(0xff16398B)),)),
              ),
            ],
          ),
        );
      });
}

class GroupMembersList extends StatelessWidget {
  final List<AppUser>? users;
  const GroupMembersList({
    super.key,
    required this.users,
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
        itemBuilder: (BuildContext context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(MdiIcons.account,color: Colors.white,),
                SizedBox(
                  width: 8,
                ),
                Expanded(child: Text(widget.users![index].email!)),
                Checkbox(
                    tristate: true,
                    value: isCheked,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheked = value;
                      });
                    },
                    activeColor: Colors.white,),
              ],
            ),
          );
        });
  }
}
