import 'package:flutter/material.dart';
import '../models/issued_book.dart';
import '../providers/issued_book_provider.dart';

class IssuedBookTile extends StatelessWidget {
  final IssuedBook issuedBook;
  final IssuedBookProvider provider;

  IssuedBookTile({required this.issuedBook, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(issuedBook.bookTitle), // <-- use bookTitle
      subtitle: Text('Issued to: ${issuedBook.userName}\nStatus: ${issuedBook.status}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (issuedBook.status == "Issued")
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => provider.returnBook(issuedBook.id),
            ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => provider.deleteIssuedBook(issuedBook.id),
          ),
        ],
      ),
    );
  }
}
