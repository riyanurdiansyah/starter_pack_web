import '../../dashboard/model/multiple_choice_m.dart';
import 'answer_m.dart';

class QuizSessionM {
  final String userId;
  final List<MultipleChoiceM> multipleChoices;
  final String quizId;
  final String sessionId;
  final List<AnswerM> answers;
  final double time;
  final int point;
  final bool isFinished;

  QuizSessionM({
    required this.userId,
    required this.multipleChoices,
    required this.quizId,
    required this.sessionId,
    required this.answers,
    required this.time,
    required this.point,
    required this.isFinished,
  });

  // copyWith method
  QuizSessionM copyWith({
    String? userId,
    List<MultipleChoiceM>? multipleChoices,
    String? quizId,
    String? sessionId,
    List<AnswerM>? answers,
    double? time,
    int? point,
    bool? isFinished,
  }) {
    return QuizSessionM(
      userId: userId ?? this.userId,
      multipleChoices: multipleChoices ?? this.multipleChoices,
      quizId: quizId ?? this.quizId,
      sessionId: sessionId ?? this.sessionId,
      answers: answers ?? this.answers,
      time: time ?? this.time,
      point: point ?? this.point,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  factory QuizSessionM.fromJson(Map<String, dynamic> json) {
    return QuizSessionM(
      userId: json['userId'],
      multipleChoices: (json['multipleChoices'] as List<dynamic>)
          .map((e) => MultipleChoiceM.fromJson(e as Map<String, dynamic>))
          .toList(),
      quizId: json['quizId'],
      sessionId: json['sessionId'],
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerM.fromJson(e as Map<String, dynamic>))
          .toList(),
      time: json['time'],
      point: json['point'],
      isFinished: json['isFinished'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'multipleChoices': multipleChoices.map((e) => e.toJson()).toList(),
      'quizId': quizId,
      'sessionId': sessionId,
      'answers': answers.map((e) => e.toJson()).toList(),
      'time': time,
      'point': point,
      'isFinished': isFinished,
    };
  }
}
