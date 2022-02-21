enum Type { water, electricity }

class Customer {
  String id;
  String fullName;
  int currentBillAmount;
  int currentBillbalance;
  Type type;
  String createdAt;
  String updatedAt;

  Customer(this.id, this.fullName, this.currentBillAmount,
      this.currentBillbalance, this.type, this.createdAt, this.updatedAt);
}

class WaterCosumption {
  String id;
  String cutomerId;
  String createdAt;
  int cm;

  WaterCosumption(this.id, this.cutomerId, this.createdAt, this.cm);
}

class WaterBill {
  String id;
  String customerId;
  String createdAt;
  int currentCM;
  int previousCM;
  int cm;
  int billAmount;
  int balance;
  int totalAmount;

  WaterBill(
    this.id,
    this.customerId,
    this.createdAt,
    this.currentCM,
    this.previousCM,
    this.cm,
    this.billAmount,
    this.balance,
    this.totalAmount,
  );
}
