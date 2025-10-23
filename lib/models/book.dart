

class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final int quantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.quantity,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'].toString(),
      author: json['author'].toString(),
      category: json['category'].toString(),
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "category": category,
    "quantity": quantity,
  };
}
