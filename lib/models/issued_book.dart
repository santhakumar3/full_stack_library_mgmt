class IssuedBook {
  final int id;
  final int bookId;      // <-- required
  final int userId;      // <-- required
  final String bookTitle;
  final String author;
  final DateTime issueDate;
  final String userName;
  final DateTime returnDate; // <-- required
  String status;           // <-- new, mutable field

  IssuedBook({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.bookTitle,
    required this.author,
    required this.issueDate,
    required this.userName,
    required this.returnDate,
    this.status = "Issued", // default status

  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'bookTitle': bookTitle,
      'author': author,
      'issueDate': issueDate.toIso8601String(),
      'userName': userName,
      'returnDate': returnDate.toIso8601String(),
      'status': status,
    };
  }

  // Create object from JSON
  factory IssuedBook.fromJson(Map<String, dynamic> json) {
    return IssuedBook(
      id: json['id'],
      bookId: json['bookId'],
      userId: json['userId'],
      bookTitle: json['bookTitle'],
      author: json['author'],
      issueDate: DateTime.parse(json['issueDate']),
      userName: json['userName'],
      returnDate: DateTime.parse(json['returnDate']),
      status: json['status'] ?? "Issued",
    );
  }
}




