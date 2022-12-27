

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/infra/app_router.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class ItemListPage extends StatelessWidget {

  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return BlocBuilder<ItemListBloc, ItemListState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = state.items[index];
              return ListTile(
                title: Text("${item.name} [${item.id.publicKey.toBase58()}]"),
                onTap: () {
                  router.push(ItemDetailsRoute(address: item.id.publicKey.toBase58()));
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {  
              context.itemListBloc.add(ItemAdded("test"));
            },
          ),
        );
      }
    );
  }

}

