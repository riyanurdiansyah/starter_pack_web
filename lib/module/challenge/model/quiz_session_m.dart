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
  final double point;
  final bool isFinished;
  final bool isRated;
  final String createdAt;
  final String updatedAt;
  final String type;
  final String remark;
  final int page;
  final bool isRevenue;

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
    required this.updatedAt,
    required this.type,
    required this.remark,
    required this.page,
    required this.isRevenue,
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
    double? point,
    bool? isFinished,
    bool? isRated,
    String? createdAt,
    String? updatedAt,
    String? type,
    String? remark,
    int? page,
    bool? isRevenue,
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
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      remark: remark ?? this.remark,
      page: page ?? this.page,
      isRevenue: isRevenue ?? this.isRevenue,
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
      isRevenue: json['isRevenue'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      remark: json['remark'] ?? "",
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
      'updatedAt': updatedAt,
      'image': image,
      'remark': remark,
      'isRevenue': isRevenue,
      'type': type,
    };
  }
}
