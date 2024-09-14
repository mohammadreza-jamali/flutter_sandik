import 'package:event_bus/event_bus.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/core/entities/dtos/theme_dto.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/category_page.dart';
import 'package:flutter_sandik/pages/group_page.dart';
import 'package:flutter_sandik/pages/home_screen.dart';
import 'package:flutter_sandik/pages/report_page.dart';
import 'package:flutter_sandik/pages/setting_page.dart';
import 'package:flutter_sandik/widgets/budget_overlay_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.group, this.user}) : super(key: key);

  final AppUser? user;
  final Group group;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  late ThemeManager _themeManager;
  late EventBus _eventBus;
  late ThemeDto currentTheme;
  late SharedPreferenceManager _preference;
  late Map<int,Function> navigationItems={
    1: _setTheme,
  } ;
  late int selectedScreenIndex;

  

  @override
  void initState() {
    super.initState();
    _eventBus = locator<EventBus>();
    _eventBus.on<ThemeDto>().listen(_themeEventHandle);
    _themeManager=locator<ThemeManager>();
    currentTheme = _themeManager.getTheme();
    _preference=SharedPreferenceManager.getInstanse();
    selectedScreenIndex=0;
  }
   _themeEventHandle(ThemeDto event) {
    currentTheme = event;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            bottomNavigationBar: Directionality(
              textDirection: TextDirection.rtl,
              child: FlashyTabBar(
                backgroundColor: Color(0xff050119),
                animationCurve: Curves.easeInOutExpo,
                animationDuration: Duration(milliseconds: 500),
                selectedIndex: selectedScreenIndex,
                height: 55,
                items: [
                FlashyTabBarItem(icon: Icon(MdiIcons.home,color: Colors.white,), title: Text('خانه',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),)),
                FlashyTabBarItem(icon: Icon(MdiIcons.selectGroup,color: Colors.white,), title: Text('دسته بندی',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),)),
                FlashyTabBarItem(icon: Icon(MdiIcons.accountTie,color: Colors.white,), title: Text('پروفایل',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),)),
                FlashyTabBarItem(icon: Icon(MdiIcons.chartArc,color: Colors.white,), title: Text('گزارش',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),)),
              ], 
              onItemSelected: (index)=> setState(() {
                selectedScreenIndex=index;
              })
              
              ),
            ),
            body: IndexedStack(
              index: selectedScreenIndex,
              children: [
                BudgetOverlayView(groupId: widget.group.groupId!,groupName: widget.group.groupName!),
                CategoryPage(widget.group.groupId!),
                SettingPage(),
                ReportPage()
              ],
            )),
    );
  }

  _setTheme() {
    currentTheme.themeName =
        currentTheme.themeName == ThemeNames.Light ? ThemeNames.Dark : ThemeNames.Light;
    _preference.setThemeName(currentTheme.themeName == ThemeNames.Light
        ? ThemeNames.Light.toString()
        : ThemeNames.Dark.toString());
    _themeManager.createTheme();
  }

}


