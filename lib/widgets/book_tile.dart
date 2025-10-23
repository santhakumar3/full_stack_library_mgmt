import 'package:flutter/material.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final BookProvider provider;

  BookTile({required this.book, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} | ${book.category} | Quantity: ${book.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {
            provider.updateBook(book); // call dialog for edit handled in screen
          }),
          IconButton(icon: Icon(Icons.delete), onPressed: () => provider.deleteBook(book.id)),
        ],
      ),
    );
  }
}
