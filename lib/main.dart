import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_1/controller/item_controller.dart';
import 'package:task_1/view/item_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ItemsScreen(),
    );
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ItemController(context: context)..loadItemsFromNetwork(),
        child: const ItemView(),
      ),
    );
  }
}
