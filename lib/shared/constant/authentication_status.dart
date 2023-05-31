enum AuthenticationStatus {
  pending('Pending for Authentication', 'Pending'),
  authenticated('Authenticated', 'Authenticated'),
  rejected('Rejected for Authentication', 'Rejected');

  final String authenticationText;
  final String summaryText;

  const AuthenticationStatus(this.authenticationText, this.summaryText);
}
