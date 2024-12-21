import '../../dashboard/model/multiple_choice_m.dart';
import 'answer_m.dart';

class QuizSessionM {
  final String userId;
  final String username;
  final List<MultipleChoiceM> multipleChoices;
  final String quizId;
  final String sessionId;
  final String groupId;
  final String image;
  final List<AnswerM> answers;
  final double time;
  final int point;
  final bool isFinished;
  final bool isRated;
  final String createdAt;
  final String type;
  final int page;

  QuizSessionM({
    required this.userId,
    required this.username,
    required this.multipleChoices,
    required this.quizId,
    required this.sessionId,
    required this.groupId,
    required this.image,
    required this.answers,
    required this.time,
    required this.point,
    required this.isFinished,
    required this.isRated,
    required this.createdAt,
    required this.type,
    required this.page,
  });

  // copyWith method
  QuizSessionM copyWith({
    String? userId,
    String? username,
    List<MultipleChoiceM>? multipleChoices,
    String? quizId,
    String? sessionId,
    String? groupId,
    String? image,
    List<AnswerM>? answers,
    double? time,
    int? point,
    bool? isFinished,
    bool? isRated,
    String? createdAt,
    String? type,
    int? page,
  }) {
    return QuizSessionM(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      multipleChoices: multipleChoices ?? this.multipleChoices,
      quizId: quizId ?? this.quizId,
      sessionId: sessionId ?? this.sessionId,
      groupId: groupId ?? this.groupId,
      image: image ?? this.image,
      answers: answers ?? this.answers,
      time: time ?? this.time,
      point: point ?? this.point,
      isFinished: isFinished ?? this.isFinished,
      isRated: isRated ?? this.isRated,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      page: page ?? this.page,
    );
  }

  factory QuizSessionM.fromJson(Map<String, dynamic> json) {
    return QuizSessionM(
      userId: json['userId'],
      username: json['username'],
      multipleChoices: (json['multipleChoices'] as List<dynamic>)
          .map((e) => MultipleChoiceM.fromJson(e as Map<String, dynamic>))
          .toList(),
      quizId: json['quizId'],
      image: json['image'] ?? "",
      sessionId: json['sessionId'] ?? "",
      groupId: json['groupId'] ?? "",
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerM.fromJson(e as Map<String, dynamic>))
          .toList(),
      time: json['time'],
      point: json['point'],
      isFinished: json['isFinished'],
      isRated: json['isRated'] ?? false,
      createdAt: json['createdAt'] ?? "",
      type: json['type'] ?? "",
      page: 0,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'multipleChoices': multipleChoices.map((e) => e.toJson()).toList(),
      'quizId': quizId,
      'sessionId': sessionId,
      'groupId': groupId,
      'answers': answers.map((e) => e.toJson()).toList(),
      'time': time,
      'point': point,
      'isFinished': isFinished,
      'isRated': isRated,
      'createdAt': createdAt,
      'image': image,
      'type': type,
    };
  }
}
