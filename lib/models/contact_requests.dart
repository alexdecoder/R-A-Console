class ContactRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String number;
  final String request;
  final String date;
  final String uuid;
  ContactRequest(
      {required this.firstName,
      required this.lastName,
      required this.date,
      required this.email,
      required this.number,
      required this.request,
      required this.uuid});
}

List<ContactRequest> contactRequests = [];
