import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sandik/core/constants/app_style.dart';
import 'package:flutter_sandik/model/transaction_per_month.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/widgets/hint_color_container.dart';
import 'package:provider/provider.dart';

class GroupReport extends StatefulWidget {
  const GroupReport(this.groupId,{Key? key}) : super(key: key);
  final String groupId;
  @override
  State<GroupReport> createState() => _GroupReportState();
}

class _GroupReportState extends State<GroupReport> {
  ValueNotifier<bool> _reportIsLoaded=ValueNotifier(false);
  List<TransactionPerMonth>? _transactions=[];
  @override
  void initState() {
    super.initState();
    _getReport();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Group Report"),
      ),
      body: ValueListenableBuilder<bool>(valueListenable: _reportIsLoaded,
       builder: (context, value, child) {
         if(value) return _renderPageContent();
        return Center(child:CircularProgressIndicator());
       },)
    );
  }

  _renderPageContent(){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
         margin: EdgeInsets.only(top: 4),
        child: ListView.builder(
          itemCount: _transactions?.length??0,
          itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
            child: ExpansionTile(title: Text(_transactions![index].humanReadbleMonth!),
            collapsedBackgroundColor: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).canvasColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              HintColorContainer( Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estimated Budget"),
                    Text("${_transactions![index].plannedBudget}")
                  ],
                ),
              ),
              HintColorContainer(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Paied Amount"),
                  Text("${_transactions![index].sum}")
                ],
              ),),
              HintColorContainer(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Paied Over Budget"),
                  Text("${_transactions![index].overPayed}",style: TextStyle(color: _transactions![index].overPayed!>=0?AppStyle.deepGreen:AppStyle.deepRed),)
                ],
              ),),
              Divider(),
              ListView.builder(itemCount: _transactions![index].transaction?.length??0,
              shrinkWrap: true,
              physics:NeverScrollableScrollPhysics() ,
              itemBuilder: (context, internalIndex) {
                var _transaction=_transactions![index].transaction![internalIndex];
                  return ListTile(leading: Icon(Icons.currency_lira),
                  title: Text(_transaction.description??""),
                  trailing: Text(_transaction.amount.toString()),);
              } 
                
              , )
            ],
            ),
          );
        }),
          ),
    );
  }
  
  void _getReport() async {
    _reportIsLoaded.value=false;
    final _transaction = context.read<MTransaction>();
    _transactions=await _transaction.getTransactionsMonthlyReport(widget.groupId);
    _reportIsLoaded.value=true;
  }
}