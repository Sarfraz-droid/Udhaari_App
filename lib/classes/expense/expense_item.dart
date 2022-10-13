class ExpenseItem {
  final String? name;
  final String? message;
  double? amount;
  final String? uid;
  bool isDirty;

  ExpenseItem(
      {this.name, this.message, this.amount, this.uid, this.isDirty = false});

  toJSON() {
    return {
      "name": name,
      "amount": amount,
      "uid": uid,
      "isDirty": isDirty,
    };
  }

  factory ExpenseItem.fromJSON(Map<String, dynamic> json) {
    return ExpenseItem(
      message: json['message'] ?? "",
      name: json['name'],
      amount: json['amount'],
      uid: json['uid'],
      isDirty: json['isDirty'] ?? false,
    );
  }
}
