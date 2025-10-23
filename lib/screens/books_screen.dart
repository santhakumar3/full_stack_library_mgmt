import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<void> _booksFuture;

  @override
  void initState() {
    super.initState();
    // ✅ Fetch only once
    _booksFuture = Provider.of<BookProvider>(context, listen: false).fetchBooks();
    debugPrint("📡 Books fetch initiated once in initState()");
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      body: FutureBuilder(
        future: _booksFuture, // ✅ use cached future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint("❌ Error fetching books: ${snapshot.error}");
            return const Center(
              child: Text(
                'Failed to load books ❗',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          }

          if (bookProvider.books.isEmpty) {
            debugPrint("⚠️ No books found in the list.");
            return const Center(
              child: Text(
                'No books found 📖',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          debugPrint("✅ Loaded books count: ${bookProvider.books.length}");

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF2D2A4A),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${book.author} | ${book.category} | Quantity: ${book.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5F5F6E),
                      ),
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 10,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () {
                          _showBookDialog(context, bookProvider, book: book);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _confirmDelete(context, bookProvider, book.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9C6FF),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () => _showBookDialog(context, bookProvider),
        child: const Icon(Icons.add, color: Color(0xFF4B0082), size: 28),
      ),
    );
  }

  void _confirmDelete(BuildContext context, BookProvider provider, int id) {
    debugPrint("🗑️ Attempting to delete book ID: $id");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.deleteBook(id);
              debugPrint("✅ Book deleted (ID: $id)");
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBookDialog(BuildContext context, BookProvider provider, {Book? book}) {
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final categoryController = TextEditingController(text: book?.category ?? '');
    final quantityController =
    TextEditingController(text: book?.quantity.toString() ?? '0');

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF8F4FF),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book == null ? 'Add New Book' : 'Edit Book',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B0082),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(titleController, 'Title', Icons.book),
                const SizedBox(height: 10),
                _buildTextField(authorController, 'Author', Icons.person),
                const SizedBox(height: 10),
                _buildTextField(categoryController, 'Category', Icons.category),
                const SizedBox(height: 10),
                _buildTextField(quantityController, 'Quantity', Icons.numbers,
                    isNumber: true),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B0082),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final newBook = Book(
                          id: book?.id ?? 0,
                          title: titleController.text.trim(),
                          author: authorController.text.trim(),
                          category: categoryController.text.trim(),
                          quantity: int.tryParse(quantityController.text) ?? 0,
                        );

                        if (book == null) {
                          provider.addBook(newBook);
                          debugPrint("🆕 Added new book: ${newBook.title}");
                        } else {
                          provider.updateBook(newBook);
                          debugPrint("✏️ Updated book: ${newBook.title}");
                        }
                        Navigator.pop(context);
                      },
                      child: Text(book == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF4B0082)),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
