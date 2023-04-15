enum SportsType{
  football ('Football'),
  badminton('Badminton'),
  volleyball('Volleyball'),
  basketball('Basketball'),
  tennis('Tennis'),
  tableTennis('Table Tennis'),
  jogging('Jogging'),
  hiking('Hiking'),
  rollerBlade('Roller Blade'),
  swimming('Swimming'),
  bowling('Bowling'),
  golf('Golf');

  final String sportsName;

  const SportsType(this.sportsName);
}