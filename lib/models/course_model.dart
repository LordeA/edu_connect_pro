class CourseModel {
  final String id;
  final String teacherId;
  final String title;
  final String description;
  final String category;
  final String coverURL;
  final int chaptersCount;
  final int inscritCount;
  final bool isPublished;

  CourseModel({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.category,
    required this.coverURL,
    required this.chaptersCount,
    required this.inscritCount,
    required this.isPublished,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> m) => CourseModel(
        id: id,
        teacherId: m['teacherId'] as String? ?? '',
        title: m['title'] as String? ?? '',
        description: m['description'] as String? ?? '',
        category: m['category'] as String? ?? '',
        coverURL: m['coverURL'] as String? ?? '',
        chaptersCount: (m['chapitresCompte'] as int?) ?? 0,
        inscritCount: (m['inscritCount'] as int?) ?? 0,
        isPublished: (m['isPublié'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'teacherId': teacherId,
        'title': title,
        'description': description,
        'category': category,
        'coverURL': coverURL,
        'chapitresCompte': chaptersCount,
        'inscritCount': inscritCount,
        'isPublié': isPublished,
      };
}
