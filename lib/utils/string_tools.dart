
DateTime stringToDateTime(String stringAsDate) {
  List<String> dateAsList = stringAsDate.split("/");
  return DateTime(int.parse(dateAsList[2]), int.parse(dateAsList[0]),
      int.parse(dateAsList[1]));
}