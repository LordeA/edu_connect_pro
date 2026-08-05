class ChapterModel {
  final String id;
  final String title;
  final String content; // markdown
  final int order;
  final bool hasQuiz;

  ChapterModel({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    required this.hasQuiz,
  });

  factory ChapterModel.fromMap(String id, Map<String, dynamic> m) => ChapterModel(
        id: id,
        title: m['title'] as String? ?? '',
        content: m['contenu'] as String? ?? '',
        order: (m['ordre'] as int?) ?? 0,
        hasQuiz: (m['hasQuiz'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'contenu': content,
        'ordre': order,
        'hasQuiz': hasQuiz,
      };
}
