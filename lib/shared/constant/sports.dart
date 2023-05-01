import 'package:jomsports/shared/constant/asset.dart';

enum SportsType{
  football ('Football', AssetConstant.football),
  badminton('Badminton', AssetConstant.badminton),
  volleyball('Volleyball', AssetConstant.volleyball),
  basketball('Basketball', AssetConstant.basketball),
  tennis('Tennis', AssetConstant.tennis),
  tableTennis('Table Tennis', AssetConstant.tableTennis),
  jogging('Jogging', AssetConstant.jogging),
  hiking('Hiking', AssetConstant.hiking),
  rollerBlade('Roller Blade', AssetConstant.rollerBlade),
  swimming('Swimming', AssetConstant.swimming),
  bowling('Bowling', AssetConstant.bowling),
  golf('Golf', AssetConstant.golf);

  final String sportsName;
  final String mapMarker;

  const SportsType(this.sportsName, this.mapMarker);
}