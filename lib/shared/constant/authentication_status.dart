enum AuthenticationStatus{
  pending ('Pending for Authentication'),
  authenticated ('Authenticated'),
  rejected ('Rejected for Authentication');

  final String authenticationText;

  const AuthenticationStatus(this.authenticationText);
}