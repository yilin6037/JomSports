enum AppointmentStatus{
  appointmentMade ('Appointment Made'),
  canceled ('Appointment Canceled');

  final String statusText;

  const AppointmentStatus(this.statusText);
}