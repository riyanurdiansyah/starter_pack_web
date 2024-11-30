import 'dart:convert';

MultipleChoiceM multipleChoiceMFromJson(String str) =>
    MultipleChoiceM.fromJson(json.decode(str));

String multipleChoiceMToJson(MultipleChoiceM data) =>
    json.encode(data.toJson());

class MultipleChoiceM {
  final String id;
  final String challengeId;
  final List<Option> options;
  final String question;
  final String type;

  MultipleChoiceM({
    required this.id,
    required this.challengeId,
    required this.options,
    required this.question,
    required this.type,
  });

  MultipleChoiceM copyWith({
    String? id,
    String? challengeId,
    List<Option>? options,
    String? question,
    String? type,
  }) =>
      MultipleChoiceM(
        id: id ?? this.id,
        challengeId: challengeId ?? this.challengeId,
        options: options ?? this.options,
        question: question ?? this.question,
        type: type ?? this.type,
      );

  factory MultipleChoiceM.fromJson(Map<String, dynamic> json) =>
      MultipleChoiceM(
        id: json["id"],
        challengeId: json["challenge_id"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        question: json["question"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "challenge_id": challengeId,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "question": question,
        "type": type,
      };
}

class Option {
  final String answer;
  final bool correct;

  Option({
    required this.answer,
    required this.correct,
  });

  Option copyWith({
    String? answer,
    bool? correct,
  }) =>
      Option(
        answer: answer ?? this.answer,
        correct: correct ?? this.correct,
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        answer: json["answer"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "correct": correct,
      };
}
