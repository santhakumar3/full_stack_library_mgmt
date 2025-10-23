import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'package:logger/logger.dart';

class BookProvider with ChangeNotifier {
  List<Book> books = [];
  final Logger logger = Logger();

  // Fetch books from API
  Future<void> fetchBooks() async {
    try {
      logger.i("Fetching books from API...");
      books = await ApiService.getBooks();
      logger.i("Books_Fetched books successfully. Total: ${books.length}");
      for (var b in books) {
        logger.i("Books_Book: ${b.toJson()}");
      }
      notifyListeners();
    } catch (e) {
      logger.e("Books_Error fetching books: $e");
    }
  }

  // Add a new book
  Future<void> addBook(Book book) async {
    try {
      logger.i("Books_Adding book: ${book.toJson()}");
      await ApiService.addBook(book);
      logger.i("Books_Book added successfully, fetching updated list...");
      await fetchBooks();
    } catch (e) {
      logger.e("Books_Error adding book: $e");
    }
  }

  // Update existing book
  Future<void> updateBook(Book book) async {
    try {
      logger.i("Books_Updating book: ${book.toJson()}");
      await ApiService.updateBook(book);
      logger.i("Books_Book updated successfully, fetching updated list...");
      await fetchBooks();
    } catch (e) {
      logger.e("Books_Error updating book: $e");
    }
  }

  // Delete a book
  Future<void> deleteBook(int id) async {
    try {
      logger.i("Books_Deleting book with id: $id");
      await ApiService.deleteBook(id);
      logger.i("Books_Book deleted successfully, fetching updated list...");
      await fetchBooks();
    } catch (e) {
      logger.e("Books_Error deleting book: $e");
    }
  }
}
