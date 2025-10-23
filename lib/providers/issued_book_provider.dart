import 'package:flutter/material.dart';
import '../models/issued_book.dart';

class IssuedBookProvider extends ChangeNotifier {
  List<IssuedBook> _issuedBooks = [];
  bool _isLoading = false;

  List<IssuedBook> get issuedBooks => _issuedBooks;
  bool get isLoading => _isLoading;

  // Example: Fetch issued books (simulate API)
  Future<void> fetchIssuedBooks() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2)); // simulate network call

    _issuedBooks = [
      IssuedBook(
        id: 1,
        bookId: 101,
        userId: 1001,
        bookTitle: 'Flutter Basics',
        author: 'Santha Kumar',
        userName: 'John Doe',
        issueDate: DateTime.now(),
        returnDate: DateTime.now().add(Duration(days: 7)),
        status: "Issued",
      ),
      IssuedBook(

        id: 2,
        bookId: 102,
        userId: 1002,
        bookTitle: 'Dart Advanced',
        author: 'Jane Smith',
        userName: 'Alice',
        issueDate: DateTime.now().subtract(Duration(days: 3)),
        returnDate: DateTime.now().add(Duration(days: 4)),
        status: "Issued",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Mark a book as returned
  void returnBook(int id) {
    final index = _issuedBooks.indexWhere((book) => book.id == id);
    if (index != -1) {
      _issuedBooks[index].status = "Returned";
      notifyListeners();
    }
  }

  // Delete a book
  void deleteIssuedBook(int id) {
    _issuedBooks.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  // Add a new issued book
  void addIssuedBook(IssuedBook book) {
    _issuedBooks.add(book);
    notifyListeners();
  }
}
