class MyItem {
  final String id;
  final String name;
  final String note;
  final String categoryID;
  final bool isCompleted;

  MyItem({required this.name, required this.note, required this.categoryID, required this.isCompleted, required this.id});

  MyItem copyWith({String? name, String? note, bool? isCompleted}) {
    return MyItem(
      name: name ?? this.name,
      note: note ?? this.note,
      categoryID: categoryID,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id,
    );
  }
}