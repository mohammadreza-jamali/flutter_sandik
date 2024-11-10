import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/core/entities/dtos/theme_dto.dart';
import 'package:flutter_sandik/locale_keys.g.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/add_group_page.dart';
import 'package:flutter_sandik/pages/home_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage(this.user);
  final AppUser user;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group>? _groups;

  late ThemeManager _themeManager;
  late EventBus _eventBus;
  late ThemeDto currentTheme;
  late SharedPreferenceManager _preference;

  @override
  void initState() {
    super.initState();
    _eventBus = locator<EventBus>();
    _eventBus.on<ThemeDto>().listen(_themeEventHandle);
    _themeManager = locator<ThemeManager>();
    currentTheme = _themeManager.getTheme();
    _preference = SharedPreferenceManager.getInstanse();
  }

  _themeEventHandle(ThemeDto event) {
    currentTheme = event;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff050119),
        floatingActionButton: Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: EdgeInsets.only(left: 128, right: 96),
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupPage(group: Group())));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.accountMultiplePlusOutline,
                      
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'افزودن گروه',
                      
                    )
                  ],
                ),
              ),
            )),
        appBar: AppBar(
            elevation: 18,
            toolbarHeight: 80,
            backgroundColor: Color(0xff050119),
            surfaceTintColor: Color(0xff050119),
            title: Text(
              LocaleKeys.groupPage_pageTitle,
              style: TextStyle(color: Colors.white),
            ).tr(),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  MdiIcons.backburger,
                  color: Colors.white,
                )),
              actions: [
                IconButton(onPressed: (){
                  _settingBottomSheet(context);
                }, icon:Icon(MdiIcons.cogOutline,color: Colors.white,))
              ],),
        body: Column(
          children: [
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: _getGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_groups == null || _groups?.length == 0) {
                      return Center(
                        child: Text("Your Not Subscribed In Any Group"),
                      );
                    }
                    return ListView.builder(
                      itemCount: _groups!.length,
                      itemBuilder: (context, index) {
                        return Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Slidable(
                              endActionPane: ActionPane(motion: StretchMotion(), extentRatio: 1, children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteGroup(_groups![index].groupId!);
                                    _groups!.removeAt(index);
                                  },
                                  backgroundColor: Color(0xff202040),
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddGroupPage(group: _groups![index]),
                                    ));
                                  },
                                  backgroundColor: Color(0xff202040),
                                  foregroundColor: Color(0xff4E9F3D),
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ]),
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          user: widget.user,
                                          group: _groups![index],
                                        ))),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Color(0xff202040).withOpacity(0.2), borderRadius: BorderRadius.circular(12), boxShadow: [
                                      BoxShadow(color: Color.fromARGB(31, 32, 30, 30), blurRadius: 5),
                                    ]),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          child: Icon(
                                            size: 30,
                                            MdiIcons.accountGroupOutline,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                            child: Text(
                                          _groups![index].groupName ?? "group name",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )),
                                        Icon(
                                          MdiIcons.chevronLeft,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  _signOut() async {
    final _userModel = context.read<UserModel>();
    await _userModel.signOut();
  }

  _getGroups() async {
    final _transaction = context.read<MTransaction>();
    _groups = [];
    _groups = await _transaction.getGroups(widget.user.userId!);
  }

  _deleteGroup(String groupId) async {
    final _transaction = context.read<MTransaction>();
    _groups = [];
    _groups = await _transaction.deleteGroup(groupId);
  }
}

Future _settingBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: ui.Radius.circular(35), topRight: ui.Radius.circular(35)),
              color: Color(0xff03001C),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.cogOutline,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'SETTINGS',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 64,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Theme :',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    CustomDropdown(
                      items: const {
                        0: 'روشن',
                        1: 'تاریک',
                      },
                      selectedValue: SharedPreferenceManager.getInstanse().getThemeName() == ThemeNames.Light.toString() ? 0 : 1,
                      icon: Icon(MdiIcons.themeLightDark),
                      onChanged: (value) {
                        SharedPreferenceManager.getInstanse().setThemeName(value == 0 ? ThemeNames.Light.toString() : ThemeNames.Dark.toString());
                        locator<ThemeManager>().createTheme();
                      },
                      hintText: 'Chose your favorite theme',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Text('Language :', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    CustomDropdown(
                      items: const {
                        0: 'فارسی',
                        1: 'انگلیسی',
                      },
                      selectedValue: context.locale.languageCode == 'en' ? 1 : 0,
                      icon: Icon(MdiIcons.alphabetGreek),
                      onChanged: (value) {
                        context.setLocale(value == 0 ? const Locale('fa') : const Locale('en'));
                      },
                      hintText: 'Chose app Language',
                    )
                  ],
                ),
              ),
            ),
          ));
}
