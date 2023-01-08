

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
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
              debugPrint("$item");
              return ListTile(
                title: Text(item.label()),
                /*onTap: () {
                  router.push(ItemDetailsRoute(address: item.id.publicKey.toBase58()));
                },*/
                subtitle: buildItemButtons(item, context),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.itemListBloc.add(const LocationCreated("Location 1", 1));
              //context.itemListBloc.add(const ProducerCreated(1));
              context.itemListBloc.add(const ResourceCreated("Resource A"));
            },
          ),
        );
      }
    );
  }

  Row buildItemButtons(Item item, BuildContext context) {
    if(item.runtimeType == Resource) {
      return Row(
        children: [
          OutlinedButton(
            onPressed: item.initialized ? null : () {
              final resource = item as Resource;
              context.itemListBloc.add(ResourceInitialized(resource));
            },
            child: const Text("init"),
          ),
          OutlinedButton(
            onPressed: item.initialized ? () {
              final resource = item as Resource;
              context.itemListBloc.add(StorageCreated(resource, 10));
            } : null,
            child: const Text("create storage"),
          ),
          // context.itemListBloc.add(const StorageCreated(10));
        ],
      );
    }
    return Row(
      children: [
        OutlinedButton(
          onPressed: item.initialized ? null : () {
            if(item.runtimeType == Location) {
              final location = item as Location;
              context.itemListBloc.add(LocationInitialized(location));
            } else if(item.runtimeType == Producer) {
              final producer = item as Producer;
              context.itemListBloc.add(ProducerInitialized(producer));
            } else if(item.runtimeType == Storage) {
              final storage = item as Storage;
              context.itemListBloc.add(StorageInitialized(storage));
            }
          },
          child: const Text("init"),
        ),
        // context.itemListBloc.add(const StorageCreated(10));
      ],
    );
  }

}

