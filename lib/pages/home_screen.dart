import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/pages/add_budget.dart';
import 'package:flutter_sandik/pages/add_transaction.dart';
import 'package:flutter_sandik/pages/data.dart';
import 'package:flutter_sandik/pages/transactions_page.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget{
  final String groupId;
  const HomeScreen({
    super.key, required this.groupId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return  Container(
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'محمد مهدی شریفی',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        Text('09221837187',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8))
                      ]),
                )),
                MinimalButton(
                  onTap: () {},
                  icon: Assets.images.icons.user,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 14,
            right: 14,
            child: FloatContainer(groupId: widget.groupId,),
          )
        ]),
                ),
                SizedBox(height: 20,),
                Expanded(child: CostListView())
              ]),
      ),
    );
  }
}

class CostListView extends StatelessWidget {
  final List<Cost> costs = FakeCostList.costs;
   CostListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: costs.length,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
      return CostListItem(cost:costs[index]);
    });
  }
}

class CostListItem extends StatelessWidget {
  final Cost cost;
  const CostListItem({
    super.key, required this.cost,
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
        padding: const EdgeInsets.fromLTRB(8,24,8,24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('تومان',style: TextStyle(color: Colors.grey.shade600),),
            SizedBox(width: 4,),
            Text(cost.price,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Text(cost.groupName,style: TextStyle(color: Colors.white),),
              Text(cost.date,style: TextStyle(fontSize: 10,color: Colors.grey.shade600),textDirection: TextDirection.rtl,)],),
            ),
            SizedBox(width: 8,),
            Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0xffBCDFFF),borderRadius: BorderRadius.circular(5)),
              child: Icon(cost.groupIcon,color: Color(0xff1F50D3),),
            )
        ]),
      ),
    );
  }
}

class FloatContainer extends StatelessWidget {
  final groupId;
  const FloatContainer({
    super.key, this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
                    color: Color.fromARGB(98, 158, 194, 252),
                    blurRadius: 25,
                  )
        ]
      ),
      child: Stack(
        children: [
      
          ClipRRect(
            child: Assets.images.backgrounds.darkCardBackground.image(
              width: MediaQuery.of(context).size.width,
              height: 220,
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(12),
          ),
      
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1,sigmaY: 1),
              child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(0, 15, 15, 15).withOpacity(0.2)
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MinimalButton(
                          onTap: () {},
                          icon: Assets.images.icons.chart,
                        ),
                        Text(
                          'مخارج ماه اردیبهشت',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تومان',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '9,983,000',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                        child: Text('نه میلیون و نهصد و هشتاد و سه هزار تومان',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10))),
                    SizedBox(
                      height: 17,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>AddTransaction(groupId) ));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Color(0xff194DD5)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('افزودن خرج',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              CupertinoIcons.add_circled_solid,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ))
                  ],
                ),
              ),
                    ),
            ),
          ),
        ]
      ),
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
        decoration: BoxDecoration(
            color: Color(0xff16398B),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon.svg(width: 16, height: 16, color: Colors.white),
        ),
      ),
    );
  }
}

Future _settingBottomSheet(BuildContext context){
  return showModalBottomSheet(
    context: context, builder: (context)=>
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.cogOutline),
                SizedBox(width: 4,),
                Text('SETTINGS',style: TextStyle(fontSize: 16),),
              ],
            ),
            SizedBox(height: 64,),
            Row(
              children: [
                SizedBox(width: 4,),
                Text('Theme :',),
              ],
            ),
            CustomDropdown(items: const{
              0: 'روشن',
              1:'تاریک',
            },
            icon: Icon(MdiIcons.themeLightDark),
            onChanged: (){},
            hintText: 'Chose your favorite theme',),
      
            SizedBox(height: 16,),
            Row(
              children: [
                SizedBox(width: 4,),
                Text('Language :',),
              ],
            ),
            CustomDropdown(items: const{
              0: 'فارسی',
              1:'انگلیسی',
            },
            icon: Icon(MdiIcons.alphabetGreek),
            onChanged: (){},
            hintText: 'Chose app Language',)
          ],
        ),
      ),
    ),
  ));
}