class DateConstant{
  static const dateFormat = "dd-MM-yyyy HH:mm";
}

enum Day{
  
  mon('Monday', 'Mon'),
  tue('Tuesday', 'Tue'),
  wed('Wednesday', 'Wed'),
  thu('Thursday', 'Thu'),
  fri('Friday', 'Fri'),
  sat('Saturday', 'Sat'),
  sun('Sunday', 'Sun');

  final String full;
  final String short;
  
  const Day(this.full, this.short);
}