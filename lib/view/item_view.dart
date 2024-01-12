import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/item_controller.dart';

class ItemView extends StatelessWidget {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item View'),
      ),
      body: Consumer<ItemController>(
        builder: (context, itemsController, child) {
          return itemsController.loading
              ? const Center(child: CircularProgressIndicator())
              : itemsController.items.isEmpty
                  ? const Center(
                      child: Text('List Empty'),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await itemsController.startBackgroundRefresh();
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: itemsController.items.length,
                        itemBuilder: (context, index) {
                          final item = itemsController.items[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                item.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                item.fullName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    );
        },
      ),
    );
  }
}
