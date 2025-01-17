import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/format_helper.dart';
import 'package:flutter_sandik/model/loan.dart';
import 'package:flutter_sandik/pages/add_loan.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:provider/provider.dart';

class LoanPage extends StatefulWidget {
  final String groupId;
  LoanPage(this.groupId, {super.key});
  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  late MTransaction _transaction;
  int _currentIndex = 0;
  bool _moreInformation = false;
  final CarouselSliderController _controller = CarouselSliderController();
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> _pageIsLoad = ValueNotifier(false);
  List<Loan> _loans = [];

  void _scrollState() {
    _moreInformation == true
        ? _scrollController.animateTo(
            _scrollController.position.maxScrollExtent, // انتهای لیست
            duration: Duration(seconds: 2), // مدت زمان انیمیشن
            curve: Curves.easeOut, // منحنی انیمیشن
          )
        : _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getLoans());
  }

  @override
  Widget build(BuildContext context) {
    _transaction = Provider.of<MTransaction>(context, listen: true);
    double _loansAmountSum = 0;
    double _loansRemainingSum = 0;
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      controller: _scrollController,
      child: ValueListenableBuilder(
        valueListenable: _pageIsLoad,
        builder: (context, value, child) {
          if (!value) {
            return Center(child: CircularProgressIndicator());
          }
          if (_loans.isEmpty) {
            return Center(
              child: Text("هیچ وامی یافت نشد."),
            );
          }

          _loans.forEach(
            (element) {
              _loansAmountSum += element.loanTotalAmount!;
              _loansRemainingSum += element.remaining();
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
              ),
              Text(
                'وام و اقساط',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 32,
              ),
              Text("${_loansRemainingSum.round()}تومان مجموع بدهی های شما از وام ها"),
              Text("مجموع وام ها : ${_loansAmountSum.round()}"),
              SizedBox(
                height: 4,
              ),
              CarouselSlider(
                items: _loans.map((loan) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // عنوان وام

                        SizedBox(height: 20),
                        // CircularProgressIndicator: درصد پیشرفت اقساط
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: loan.getPaidPercentage(), // درصد پیشرفت
                                strokeWidth: 16.0,
                                backgroundColor: Colors.grey.shade300,
                                color: Color(0xff1b2a41),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${(loan.getPaidPercentage() * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "باز پرداخت شده",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  loan.loanName!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 280.0, // ارتفاع اسلایدر
                  enlargeCenterPage: true, // بزرگ‌نمایی اسلاید مرکزی
                  autoPlay: false, // اجرای خودکار
                  aspectRatio: 16 / 9, // نسبت ابعاد اسلاید
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    if (mounted) {
                      setState(() {
                        _currentIndex = index; // تغییر شاخص اسلاید
                      });
                    }
                  }, // عرض اسلایدها
                ),
                carouselController: _controller,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _loans.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _currentIndex == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0Xffe9e9e9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("باقی مانده وام"),
                        Text("${(_loans[_currentIndex].remaining()).round()}")
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0Xffe9e9e9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("آخرین قسط"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                "${FormatHelper.numberFormatter(((_loans[_currentIndex].getMonthlyPayment()).round()).toDouble())}"),
                            Text("${_loans[_currentIndex].remaining()}")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0Xffe9e9e9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("قسط بعدی"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _loans[_currentIndex].remaining()==0?Text("0"):Text("${(_loans[_currentIndex].getMonthlyPayment()).round()}"),
                            Text("${_loans[_currentIndex].remaining()}")
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                reverseDuration: Duration(seconds: 1),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation, // انیمیشن محو شدن
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _moreInformation
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 32),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0Xffe9e9e9),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('مبلغ وام :'),
                                  Text(
                                      '${(_loans[_currentIndex].loanTotalAmount!).round()}'),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('مبلغ بازپرداخت :'),
                                  Text(
                                      '${(_loans[_currentIndex].getRefundAmount()).round()}'),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('درصد بهره بانکی:'),
                                  Text(
                                      '${_loans[_currentIndex].loanInterestRate}%'),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' تعداد اقساط:'),
                                  Text('${_loans[_currentIndex].months}'),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' تعداد اقساط باقی مانده:'),
                                  Text(
                                      '${(_loans[_currentIndex].months)! - (_loans[_currentIndex].paidMonths)!}'),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'حذف',
                              style: TextStyle(color: Colors.blue.shade200),
                            ),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .copyWith(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24)))),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddLoan(widget.groupId)));
                            },
                            child: Text(
                              'افزودن',
                              style: TextStyle(color: Colors.blue.shade200),
                            ),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .copyWith(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24)))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _moreInformation == true
                              ? _moreInformation = false
                              : _moreInformation = true;
                          _scrollState();
                        });
                      },
                      child: _moreInformation == true
                          ? Text(
                              'کمتر',
                              style: TextStyle(color: Colors.blue.shade200),
                            )
                          : Text(
                              'بیشتر',
                              style: TextStyle(color: Colors.blue.shade200),
                            ),
                      style: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .copyWith(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(24)))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        },
      ),
    )));
  }

  Future getLoans() async {
    _pageIsLoad.value = false;
    _loans.clear();
    _loans = await _transaction.getLoans(widget.groupId);
    _pageIsLoad.value = true;
  }

  void deleteLoan(){
    
  }
}
