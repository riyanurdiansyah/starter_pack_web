class AnswerM {
  int indexAnswer;
  bool isCorrect;

  AnswerM({
    required this.indexAnswer,
    required this.isCorrect,
  });

  AnswerM copyWith({
    int? indexAnswer,
    bool? isCorrect,
  }) {
    return AnswerM(
      indexAnswer: indexAnswer ?? this.indexAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  // fromJson factory
  factory AnswerM.fromJson(Map<String, dynamic> json) {
    return AnswerM(
      indexAnswer: json['indexAnswer'],
      isCorrect: json['isCorrect'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'indexAnswer': indexAnswer,
      'isCorrect': isCorrect,
    };
  }
}
