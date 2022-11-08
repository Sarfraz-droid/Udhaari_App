class ChatUdhaar {
  double amount;

  ChatUdhaar({required this.amount});

  factory ChatUdhaar.fromJSON(Map<String, dynamic> json) {
    print(json);
    return ChatUdhaar(amount: double.parse(json['amount'].toString()));
  }

  toJSON() {
    return {
      "amount": amount,
    };
  }
}
