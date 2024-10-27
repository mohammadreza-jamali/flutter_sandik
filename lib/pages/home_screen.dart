import 'dart:ui' as ui;

import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:easy_localization/easy_localization.dart' as esy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/core/application/phone_local_helper.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/dtos/transaction_dto.dart';
import 'package:flutter_sandik/format_helper.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/add_budget.dart';
import 'package:flutter_sandik/pages/add_transaction.dart';
import 'package:flutter_sandik/pages/data.dart';
import 'package:flutter_sandik/pages/transactions_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sandik/core/application/persian_date_helper.dart';
import 'package:shamsi_date/shamsi_date.dart';

class HomeScreen extends StatefulWidget {
  final Group group;
  final AppUser currentUser;
  const HomeScreen({super.key, required this.group, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MoneyTransaction>? _transactions;
  List<Category>? _categories;
  List<AppUser>? groupUsers;
  String filterDate = "";
  late MTransaction _transaction;
  late Map<String, dynamic> transactionsInfo;
  @override
  void initState() {
    super.initState();
    filterDate = PhoneLocalHelper.phoneLocal == "ir"
        ? "${Jalali.now().year.toString().padLeft(2, "0")}${Jalali.now().month.toString().padLeft(2, "0")}"
        : "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}";
    //filterDate = "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    _transaction = Provider.of<MTransaction>(context);
    if (_transaction.state == ViewState.Idle) {
      return FutureBuilder(
          future: _getInfo(),
          builder: (context, snapshot) {
//             PanaraInfoDialog.show(
//     context,
//     title: "Hello",
//     message: "This is the PanaraInfoDialog",
//     buttonText: "Okay",
//     onTapDismiss: () {

//     },
//     panaraDialogType: PanaraDialogType.normal,
//     barrierDismissible: false, // optional parameter (default is true)
// );
            if (snapshot.connectionState == ConnectionState.done) {
              var currentUserAvatar = groupUsers!.firstWhere((user) => user.userId == widget.currentUser.userId).avatarName;
              return Container(
                color: Color(0xff050119),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(children: [
                    Container(
                      color: Color(0xff050119),
                      child: Stack(children: [
                        Container(
                          height: 330,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 230,
                              color: Color(0xff050119),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MinimalButton(
                                onTap: () {
                                  _settingBottomSheet(context);
                                },
                                icon: Assets.images.icons.question,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Directionality(
                                  child: Text(widget.group.groupName!),
                                  textDirection: ui.TextDirection.rtl,
                                ),
                              )),
                              Container(
                                  width: 35,
                                  height: 35,
                                  decoration:
                                      BoxDecoration(color: Colors.blue, border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
                                  child: currentUserAvatar == null
                                      ? Icon(Icons.person)
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.asset(
                                            "assets/images/avatars/$currentUserAvatar.jpg",
                                            fit: BoxFit.cover,
                                            width: 35,
                                            height: 35,
                                          ),
                                        ))
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 14,
                          right: 14,
                          child: FloatContainer(
                            groupId: widget.group.groupId,
                            transactionsInfo: transactionsInfo,
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: (_transactions ?? []).isNotEmpty
                            ? CostListView(costs: _transactions ?? [], categories: _categories ?? [], users: groupUsers ?? [])
                            : Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Assets.images.emptyPage.image(),
                                    ),
                                  ),
                                  Text(
                                    'هنوز چیزی خرج نکردی !',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'اولین خرجت رو اضافه کن.',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade300),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 32,
                                  )
                                ],
                              ))
                  ]),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future _getInfo() async {
    transactionsInfo = await _transaction.getTransactionInfo(widget.group.groupId!, filterDate);
    _transactions = transactionsInfo["transactions"];
    _categories = await _transaction.getAllCategories(widget.group.groupId!);
    groupUsers = await _transaction.getUsersByIds(widget.group.groupUsers!.map((user) => user.toString()).toList());
  }
}

class CostListView extends StatelessWidget {
  final List<MoneyTransaction> costs;
  final List<Category> categories;
  final List<AppUser> users;
  CostListView({
    required this.costs,
    required this.categories,
    required this.users,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: costs.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          var costCategory = categories.firstWhere((category) => category.categoryId == costs[index].categoryId);
          var user = users.firstWhere((user) => user.userId == costs[index].userId);
          return CostListItem(
              cost: costs
                  .map((cost) => TransactionDto(
                      id: cost.id,
                      userName: user.name,
                      amount: cost.amount,
                      description: cost.description,
                      insertDate: cost.insertDate,
                      month: cost.month,
                      categoryName: costCategory.categoryName,
                      icon: costCategory.icon,
                      userAvatar: user.avatarName))
                  .toList()[index]);
        });
  }
}

class CostListItem extends StatelessWidget {
  final TransactionDto cost;
  CostListItem({
    super.key,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff1B202C),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 8, 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            'تومان',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            FormatHelper.numberFormatter(cost.amount),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      cost.description ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      MdiIcons.fromString(cost.icon!),
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  FormatHelper.dateFormatter(cost.insertDate?.toDate() ?? DateTime.now()),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                )
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                //color: Color(0xffBCDFFF),
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: cost.userAvatar == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                    )
                  : Image.asset(
                      "assets/images/avatars/${cost.userAvatar}.jpg",
                      fit: BoxFit.cover,
                    ),
            ),

            // Icon(
            //   MdiIcons.fromString(cost.icon!),
            //   color: Color(0xff1F50D3),
            // ),
          )
        ]),
      ),
    );
  }
}

class FloatContainer extends StatelessWidget {
  final groupId;
  final Map<String, dynamic> transactionsInfo;
  const FloatContainer({
    required this.groupId,
    required this.transactionsInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(98, 158, 194, 252),
          blurRadius: 25,
        )
      ]),
      child: Stack(children: [
        ClipRRect(
          child: Assets.images.backgrounds.darkCardBackground.image(width: MediaQuery.of(context).size.width, height: 220, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              height: 220,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color.fromARGB(0, 15, 15, 15).withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTransaction(groupId)));
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('افزودن خرج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    CupertinoIcons.add_circled_solid,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'مخارج ${DateTime.now().toJalali().formatter.mN} ماه',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'تومان',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              (transactionsInfo["transactions"] as List<MoneyTransaction>).isEmpty
                                  ? FormatHelper.numberFormatter(0)
                                  : FormatHelper.numberFormatter((transactionsInfo["transactions"] as List<MoneyTransaction>)
                                      .map((transaction) => transaction.amount)
                                      .reduce((value, element) => (value ?? 0) + (element ?? 0))),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                                (transactionsInfo["transactions"] as List<MoneyTransaction>).isEmpty
                                    ? ""
                                    : DigitToWord.toWord(
                                            (transactionsInfo["transactions"] as List<MoneyTransaction>)
                                                .map((transaction) => transaction.amount)
                                                .reduce((value, element) => (value ?? 0) + (element ?? 0))
                                                ?.truncate()
                                                .toString(),
                                            StrType.StrWord) +
                                        ' تومان',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.transparent.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'بودجه :',
                                  textDirection: ui.TextDirection.rtl,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'تومان',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      FormatHelper.numberFormatter((transactionsInfo["budget"] as Budget?)?.budgetValue),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class MinimalButton extends StatelessWidget {
  final Function() onTap;
  final SvgGenImage icon;
  const MinimalButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Color(0xff16398B), borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon.svg(width: 16, height: 16, color: Colors.white),
        ),
      ),
    );
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
                      selectedValue: 0,
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
