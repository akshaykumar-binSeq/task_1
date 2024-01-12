import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

import '../network/api.dart';
import '../repository/database_helper.dart';
import '../model/item_model.dart';

class ItemController extends ChangeNotifier {
  BuildContext context;

  bool _loading = false;
  bool get loading => _loading;

  List<Items> _items = [];
  List<Items> get items => _items;

  ItemController({required this.context}) {}

  Isolate? _backgroundRefreshIsolate;
  final ReceivePort _refreshReceivePort = ReceivePort();

  Future<void> startBackgroundRefresh() async {
    showSnackbar(context, 'Refresh in Progress...!');
    _backgroundRefreshIsolate = await Isolate.spawn(
        _backgroundRefreshEntryPoint, _refreshReceivePort.sendPort);
    _refreshReceivePort.listen((message) async {
      if (message == 'REFRESH_COMPLETE') {
        stopBackgroundRefresh();
        await loadItems(isRefresh: true);
      }
    });
  }

  static void _backgroundRefreshEntryPoint(SendPort sendPort) async {
    // This is the entry point for the isolate, this runs on a separate thread
    final items = await API().fetchItems(DateTime.now());
    if (items != null && items.isNotEmpty) {
      await DatabaseHelper.batchInsertItems(items);
      sendPort.send('REFRESH_COMPLETE');
    }
  }

  Future<void> stopBackgroundRefresh() async {
    _backgroundRefreshIsolate?.kill(priority: Isolate.immediate);
    _backgroundRefreshIsolate = null;
  }

  @override
  void dispose() {
    super.dispose();
    stopBackgroundRefresh();
  }

  Future<void> loadItemsFromNetwork() async {
    try {
      _loading = true;
      notifyListeners();

      final items = await API().fetchItems(DateTime.now());

      if (items != null && items.isNotEmpty) {
        addItems(items);
      }
    } catch (e) {
      log('Error loading items from network: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadItems({bool isRefresh = false}) async {
    try {
      _items = await DatabaseHelper.getItems();
    } catch (e) {
      log('Error loading items from database: $e');
    } finally {
      // ignore: use_build_context_synchronously
      isRefresh ? showSnackbar(context, 'Refresh complete!') : null;
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addItems(List<Items> items) async {
    try {
      await DatabaseHelper.batchInsertItems(items);
      await loadItems(); // Reload items after adding a new one
    } catch (e) {
      log('Error adding items: $e');
    }
  }

  void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
