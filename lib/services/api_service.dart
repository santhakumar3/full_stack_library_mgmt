import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/user.dart';
import '../models/issued_book.dart';
import 'package:logger/logger.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.6/library_project/RestAPI/api';
  static final Logger logger = Logger();

  // ---------- Books API ----------
  static Future<List<Book>> getBooks() async {
  final url = Uri.parse('${baseUrl}/books.php');
  logger.i('Books_GET_Request: $url');
  final response = await http.get(url);
  logger.i('Books_GET_Response: ${response.body}');
  final List jsonData = json.decode(response.body);
  return jsonData.map((e) => Book.fromJson(e)).toList();
  }

  static Future<void> addBook(Book book) async {
  final url = Uri.parse('${baseUrl}/books.php');
  logger.i('Books_POST Request: $url | Body: ${book.toJson()}');
  final response = await http.post(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(book.toJson()));
  logger.i('Books_POST_Response: ${response.body}');
  }

  static Future<void> updateBook(Book book) async {
  final url = Uri.parse('${baseUrl}/books.php');
  logger.i('Books_PUT Request: $url | Body: ${book.toJson()}');
  final response = await http.put(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(book.toJson()));
  logger.i('Books_PUT_Response: ${response.body}');
  }

  static Future<void> deleteBook(int id) async {
  final url = Uri.parse('${baseUrl}/books.php');
  logger.i('Books_DELETE Request: $url | Body: {"id":$id}');
  final response = await http.delete(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({"id": id}));
  logger.i('Books_DELETE_Response: ${response.body}');
  }

  // ---------- Users API ----------
  static Future<List<User>> getUsers() async {
  final url = Uri.parse('${baseUrl}/users.php');
  logger.i('Users_GET Request: $url');
  final response = await http.get(url);
  logger.i('Users_GET_Response: ${response.body}');
  final List jsonData = json.decode(response.body);
  return jsonData.map((e) => User.fromJson(e)).toList();
  }

  static Future<void> addUser(User user) async {
  final url = Uri.parse('${baseUrl}/users.php');
  logger.i('Users_POST Request: $url | Body: ${user.toJson()}');
  final response = await http.post(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(user.toJson()));
  logger.i('Users_POST_Response: ${response.body}');
  }

  static Future<void> updateUser(User user) async {
  final url = Uri.parse('${baseUrl}/users.php');
  logger.i('Users_PUT Request: $url | Body: ${user.toJson()}');
  final response = await http.put(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(user.toJson()));
  logger.i('Users_PUT_Response: ${response.body}');
  }

  static Future<void> deleteUser(int id) async {
  final url = Uri.parse('${baseUrl}/users.php');
  logger.i('Users_DELETE Request: $url | Body: {"id":$id}');
  final response = await http.delete(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({"id": id}));
  logger.i('Users_DELETE_Response: ${response.body}');
  }

  // ---------- Issued Books API ----------
  static Future<List<IssuedBook>> getIssuedBooks() async {
  final url = Uri.parse('${baseUrl}/issued_books.php');
  logger.i('IssueBooks_GET Request: $url');
  final response = await http.get(url);
  logger.i('IssueBooks_GET_Response: ${response.body}');
  final List jsonData = json.decode(response.body);
  return jsonData.map((e) => IssuedBook.fromJson(e)).toList();
  }

  static Future<void> issueBook(IssuedBook issuedBook) async {
  final url = Uri.parse('${baseUrl}/issued_books.php');
  final body = {
  "book_id": issuedBook.bookId,
  "user_id": issuedBook.userId,
  "issue_date": issuedBook.issueDate,
  "return_date": issuedBook.returnDate
  };
  logger.i('IssueBooks_POST Request: $url | Body: $body');
  final response = await http.post(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(body));
  logger.i('IssueBooks_POST_Response: ${response.body}');
  }

  static Future<void> returnBook(int issueId) async {
  final url = Uri.parse('${baseUrl}/issued_books.php');
  logger.i('IssueBooks_PUT Request: $url | Body: {"issue_id":$issueId}');
  final response = await http.put(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({"issue_id": issueId}));
  logger.i('IssueBooks_PUT_Response: ${response.body}');
  }

  static Future<void> deleteIssuedBook(int id) async {
  final url = Uri.parse('${baseUrl}/issued_books.php');
  logger.i('IssueBooks_DELETE Request: $url | Body: {"id":$id}');
  final response = await http.delete(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({"id": id}));
  logger.i('IssueBooks_DELETE_Response: ${response.body}');
  }

  // ---------- Admin Auth ----------
  static Future<bool> login(String username, String password) async {
  final url = Uri.parse('${baseUrl}/auth.php');
  final body = {"username": username, "password": password};
  logger.i('Login_POST Request: $url | Body: $body');
  final response = await http.post(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode(body));
  logger.i('Login_POST_Response: ${response.body}');
  final data = json.decode(response.body);
  return data['success'] ?? false;
  }
  }








//   // Books
//   static Future<List<Book>> getBooks() async {
//     final response = await http.get(Uri.parse('$baseUrl/books.php'));
//     final List data = jsonDecode(response.body);
//     return data.map((json) => Book.fromJson(json)).toList();
//   }
//
//   static Future<String> addBook(Book book) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(book.toJson()),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> updateBook(Book book) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(book.toJson()),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> deleteBook(int id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'id': id}),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   // Users
//   static Future<List<User>> getUsers() async {
//     final response = await http.get(Uri.parse('$baseUrl/users.php'));
//     final List data = jsonDecode(response.body);
//     return data.map((json) => User.fromJson(json)).toList();
//   }
//
//   static Future<String> addUser(User user) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/users.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(user.toJson()),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> updateUser(User user) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/users.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(user.toJson()),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> deleteUser(int id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/users.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'id': id}),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   // Issued Books
//   static Future<List<IssuedBook>> getIssuedBooks() async {
//     final response = await http.get(Uri.parse('$baseUrl/issued_books.php'));
//     final List data = jsonDecode(response.body);
//     return data.map((json) => IssuedBook.fromJson(json)).toList();
//   }
//
//   static Future<String> issueBook(IssuedBook issuedBook) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/issued_books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'book_id': issuedBook.bookId,
//         'user_id': issuedBook.userId,
//         'issue_date': issuedBook.issueDate,
//         'return_date': issuedBook.returnDate,
//       }),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> returnBook(int issueId) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/issued_books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'issue_id': issueId}),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   static Future<String> deleteIssuedBook(int id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/issued_books.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'id': id}),
//     );
//     return jsonDecode(response.body)['message'];
//   }
//
//   // Admin Login
//   static Future<bool> login(String username, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/auth.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'password': password}),
//     );
//     return jsonDecode(response.body)['success'];
//   }
// }
