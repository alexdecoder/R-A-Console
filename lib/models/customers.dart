class Customer {
  final String name;
  final String phoneNumber;
  final double balance;
  final String uuid;
  Customer(
      {required this.name,
      required this.balance,
      required this.phoneNumber,
      required this.uuid});
}

List<Customer> customers = [];
