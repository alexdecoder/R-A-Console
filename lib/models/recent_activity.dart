class AccountEvent {
  final bool wasTransferedIn;
  final double amount;
  final String date;
  AccountEvent(
      {required this.wasTransferedIn,
      required this.amount,
      required this.date});
}

List<AccountEvent> recentAccountActivityEvents = [];

class IssuingEvent {
  final bool authorized;
  final double amount;
  final String date;
  final String title;
  final String cardHolder;
  final String lastFour;
  final String id;
  IssuingEvent(
      {required this.authorized,
      required this.amount,
      required this.date,
      required this.cardHolder,
      required this.lastFour,
      required this.title,
      required this.id});
}

List<IssuingEvent> recentIssuingEvents = [];
