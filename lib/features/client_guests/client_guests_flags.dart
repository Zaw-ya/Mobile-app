/// Feature switches of client guest management.
class ClientGuestsFlags {
  ClientGuestsFlags._();

  /// "Request a change" on a guest that was already sent an invitation
  /// (opens WhatsApp to customer service). Hidden until the owner asks.
  static const bool editRequestEnabled = false;
}
