import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'users_screen.dart';
import 'issued_books_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF), // soft lavender background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '📚 Library Dashboard',
          style: TextStyle(
            color: Color(0xFF3059C6),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          // Rounded TabBar container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E6FA), // soft lavender tab background
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF4B7BE5), // blue active tab
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(icon: Icon(Icons.menu_book_rounded), text: "Books"),
                Tab(icon: Icon(Icons.people_alt_rounded), text: "Users"),
                Tab(icon: Icon(Icons.assignment_turned_in_rounded), text: "Issued"),
              ],
            ),
          ),

          // Expanded Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BooksScreen(),
                UsersScreen(),
                IssuedBooksScreen(),
              ],
            ),
          ),
        ],
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9C6FF),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () {
          // You can handle tab-based actions here
          final currentTab = _tabController.index;
          if (currentTab == 0) {
            // Add Book action
          } else if (currentTab == 1) {
            // Add User action
          } else {
            // Issue Book action
          }
        },
        child: const Icon(Icons.add, color: Color(0xFF4B0082), size: 28),
      ),
    );
  }
}
