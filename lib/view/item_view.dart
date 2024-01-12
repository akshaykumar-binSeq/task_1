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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              itemsController.loading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await itemsController.startBackgroundRefresh();
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: itemsController.items.length,
                          itemBuilder: (context, index) {
                            final item = itemsController.items[index];
                            return ListTile(
                              title: Text(item.name ?? ''),
                              subtitle: Text(item.fullName ?? ''),
                              // Add other item details as needed
                            );
                          },
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
