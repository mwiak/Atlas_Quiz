// data entity represent a question

class Question {
  Question({required this.id, required this.title, required this.choices});
  late int id; // the given id of the question (hardcoded)
  late String title; // the question itself
  late List<dynamic> choices; // the choices
}
