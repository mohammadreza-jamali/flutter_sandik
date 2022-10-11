import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/core/entities/dtos/theme_dto.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/add_group.dart';
import 'package:flutter_sandik/pages/transactions_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage(this.user, {Key? key}) : super(key: key);

  final AppUser? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Group>? _groups;

  late ThemeManager _themeManager;
  late EventBus _eventBus;
  late ThemeDto currentTheme;
  late SharedPreferenceManager _preference;
  late Map<int,Function> navigationItems={
    1: _setTheme,
    0:_goToAppInfo
  } ;

  @override
  void initState() {
    super.initState();
    _eventBus = locator<EventBus>();
    _eventBus.on<ThemeDto>().listen(_themeEventHandle);
    _themeManager=locator<ThemeManager>();
    currentTheme = _themeManager.getTheme();
    _preference=SharedPreferenceManager.getInstanse();
  }
   _themeEventHandle(ThemeDto event) {
    currentTheme = event;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sandix"),
          actions: [
            IconButton(onPressed: () async=>_signOut(context), icon: Icon(Icons.exit_to_app)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).hintColor,
          child: Icon(Icons.group_add,color: currentTheme.theme.textTheme.headline1!.color,),onPressed: () => _createGroup(context) ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => navigationItems[value]!(),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 4,
          fixedColor: currentTheme.theme.textTheme.headline1!.color ,
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.info,
                      color: currentTheme.theme.textTheme.headline1!.color)
                      ,label: "About App"),
          BottomNavigationBarItem(icon: Icon(
                    currentTheme.themeName == ThemeNames.Light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: currentTheme.theme.textTheme.headline1!.color),
                    label: "Theme",
                    ),
        ]),
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
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListView.builder(
                  itemCount: _groups!.length,
                  itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(horizontal:4,vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  TransactionsPage(_groups![index].groupId!)));
                        },
                        leading: Icon(Icons.group,color: currentTheme.theme.textTheme.headline1!.color,),
                        title: Text(_groups![index].groupName ?? ""),
                      )),
                ),
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
    _groups = await _transaction.getGroups(widget.user!.userId!);
  }

  void _createGroup(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddGroup(),
    ));
  }
  _setTheme() {
    currentTheme.themeName =
        currentTheme.themeName == ThemeNames.Light ? ThemeNames.Dark : ThemeNames.Light;
    _preference.setThemeName(currentTheme.themeName == ThemeNames.Light
        ? ThemeNames.Light.toString()
        : ThemeNames.Dark.toString());
    _themeManager.createTheme();
  }
  _goToAppInfo(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddGroup(),
    ));
  }
}
