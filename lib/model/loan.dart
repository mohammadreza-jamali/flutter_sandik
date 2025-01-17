import 'dart:math';

class Loan {
   String? groupId;
   String? loanId;
   String? loanName;
   double? loanTotalAmount;
   double? loanInterestRate;
   int? months;
   int? paidMonths;

   Loan();

  Loan.init({
    required this.groupId,
    required this.loanId,
    required this.loanName,
    required this.loanTotalAmount,
    required this.loanInterestRate,
    required this.months,
    required this.paidMonths,  
    });

  // محاسبه میزان قسط ماهانه
  double getMonthlyPayment() {
    double monthlyRate = loanInterestRate! / 1200; // نرخ ماهانه بهره
    return (loanTotalAmount! * monthlyRate) /
        (1 - pow((1 / (1 + monthlyRate)),months!));
  }

  double getTotalPaid(){
    return paidMonths!*getMonthlyPayment();
  }

  double getPaidPercentage(){
    return getTotalPaid()/getRefundAmount();
  }

  double getRefundAmount(){
    return getMonthlyPayment()*months!;
  }

  double remaining(){
    return (getRefundAmount()-(getTotalPaid()));
  }


Map<String,dynamic> toMap()=>{
    "groupId": groupId,
    "loanId": loanId,
    "loanName":loanName,
    "loanInterestRate":loanInterestRate,
    "loanTotalAmount":loanTotalAmount,
    "months":months,
    "paidMonths":paidMonths,
  };

  Loan fromJson(Map<String,dynamic> json){
    groupId=json["groupId"];
    loanId=json["loanId"];
    loanName=json["loanName"];
    loanInterestRate=json["loanInterestRate"];
    loanTotalAmount=json["loanTotalAmount"];
    months=json["months"] as int?;
    paidMonths=json["paidMonths"] as int?;
    return this;
  }

}