import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/issued_book.dart';
import '../providers/issued_book_provider.dart';

class IssuedBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final issuedProvider = Provider.of<IssuedBookProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Issued Books")),
      body: issuedProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: issuedProvider.issuedBooks.length,
        itemBuilder: (context, index) {
          final book = issuedProvider.issuedBooks[index];
          return ListTile(
            title: Text(book.bookTitle),
            subtitle: Text('Issued to: ${book.userName}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                issuedProvider.deleteIssuedBook(book.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              // Controllers for input fields
              final bookIdController = TextEditingController();
              final userIdController = TextEditingController();
              final bookTitleController = TextEditingController();
              final authorController = TextEditingController();
              final userNameController = TextEditingController();
              final issueDateController = TextEditingController(
                  text: DateTime.now().toIso8601String());
              final returnDateController = TextEditingController(
                  text: DateTime.now().add(Duration(days: 7)).toIso8601String());

              return AlertDialog(
                title: Text('Add Issued Book'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: bookIdController,
                        decoration: InputDecoration(labelText: 'Book ID'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: userIdController,
                        decoration: InputDecoration(labelText: 'User ID'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: bookTitleController,
                        decoration: InputDecoration(labelText: 'Book Title'),
                      ),
                      TextField(
                        controller: authorController,
                        decoration: InputDecoration(labelText: 'Author'),
                      ),
                      TextField(
                        controller: userNameController,
                        decoration: InputDecoration(labelText: 'User Name'),
                      ),
                      TextField(
                        controller: issueDateController,
                        decoration: InputDecoration(labelText: 'Issue Date (YYYY-MM-DD)'),
                      ),
                      TextField(
                        controller: returnDateController,
                        decoration: InputDecoration(labelText: 'Return Date (YYYY-MM-DD)'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newBook = IssuedBook(
                        id: issuedProvider.issuedBooks.length + 1,
                        bookId: int.parse(bookIdController.text),
                        userId: int.parse(userIdController.text),
                        bookTitle: bookTitleController.text,
                        author: authorController.text,
                        userName: userNameController.text,
                        issueDate: DateTime.parse(issueDateController.text),
                        returnDate: DateTime.parse(returnDateController.text),
                      );

                      issuedProvider.addIssuedBook(newBook);
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
