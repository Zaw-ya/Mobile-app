/// Feature switches of client guest management.
class ClientGuestsFlags {
  ClientGuestsFlags._();

  /// "Request a change" on a guest that was already sent an invitation
  /// (opens WhatsApp to customer service). Hidden until the owner asks.
  static const bool editRequestEnabled = false;

  /// Title filter and group title changes for guests already on the list.
  /// Needs the backend's stored title and `PUT .../guests/title`, so it stays
  /// off until those are deployed; drafts don't depend on it.
  static const bool titlesOnListEnabled = false;
}
