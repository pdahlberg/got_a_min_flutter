

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/bloc/player_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/player_events.dart';
import 'package:got_a_min_flutter/domain/bloc/player_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
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
            itemCount: state.items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index < state.items.length) {
                final item = state.items[index];
                debugPrint("$item");
                return ListTile(
                  title: Text(item.label()),
                  /*onTap: () {
                  router.push(ItemDetailsRoute(address: item.id.publicKey.toBase58()));
                },*/
                  subtitle: buildItemButtons(context, item, state.items),
                );
              } else {
                return ListTile(
                  title: const Text("Toolbar"),
                  /*onTap: () {
                  router.push(ItemDetailsRoute(address: item.id.publicKey.toBase58()));
                },*/
                  subtitle: BlocBuilder<PlayerBloc, PlayerState>(
                    builder: (context, playerState) {
                      return buildToolbarButtons(context, playerState.player_, state.items);
                    }
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.itemListBloc.add(const LocationCreated("Location 1", 1, 0));
              //context.itemListBloc.add(const ProducerCreated(1));
              context.itemListBloc.add(const ResourceCreated("Resource A"));
            },
          ),
        );
      }
    );
  }

  Row buildItemButtons(BuildContext context, Item item, List<Item> items) {
    if(item.runtimeType == Producer) {
      final producer = item as Producer;
      final existingStorage = items.where((i) => i.runtimeType == Storage).map((i) => i as Storage).where((i) => i.initialized).firstOrNull;

      return Row(
        children: [
          OutlinedButton(
            onPressed: item.initialized ? null : () {
              context.itemListBloc.add(ProducerInitialized(producer));
            },
            child: const Text("init"),
          ),
          OutlinedButton(
            onPressed: item.readyToProduce && existingStorage != null ? () {
              context.itemListBloc.add(ProductionStarted(producer, existingStorage));
            } : null,
            child: Text("produce ${producer.resource.name}"),
          ),
        ],
      );
    } else if(item.runtimeType == Resource) {
      return Row(
        children: [
          OutlinedButton(
            onPressed: item.initialized ? null : () {
              final resource = item as Resource;
              context.itemListBloc.add(ResourceInitialized(resource));
            },
            child: const Text("init"),
          ),
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

  Widget buildToolbarButtons(BuildContext context, Player? player, List<Item> items) {
    final setupNeeded = items.isEmpty;
    final existingLocation = items.where((i) => i.runtimeType == Location).map((i) => i as Location).where((i) => i.initialized).firstOrNull;
    final existingResource = items.where((i) => i.runtimeType == Resource).map((i) => i as Resource).where((i) => i.initialized).firstOrNull;
    final canCreateProducer = existingLocation != null && existingResource != null && player != null;
    final canCreateStorage = existingLocation != null && existingResource != null && player != null;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: [
        OutlinedButton(
          onPressed: () {
            context.itemListBloc.add(const HeartbeatEnabledProducer(true));
          },
          child: const Text("Auto Produce"),
        ),
        OutlinedButton(
          onPressed: () {
            context.itemListBloc.add(const HeartbeatEnabledProductionSync(true));
          },
          child: const Text("Local Prod Sync"),
        ),
        if(setupNeeded) OutlinedButton(
          onPressed: setupNeeded ? () {
            context.itemListBloc.add(const LocationCreated("Location 1", 1, 0));
            context.itemListBloc.add(const ResourceCreated("Resource A"));
            context.playerBloc.add(const PlayerCreated());
          } : null,
          child: const Text("Setup"),
        ),
        Text(player?.name ?? "No player"),
        OutlinedButton(
          onPressed: () {
            context.playerBloc.add(const PlayerCreated());
          },
          child: const Text("+P"),
        ),
        OutlinedButton(
          onPressed: player == null ? null : () {
            context.playerBloc.add(PlayerNextActivated(player));
          },
          child: const Text("P>>"),
        ),
        OutlinedButton(
          onPressed: canCreateProducer ? () {
            context.itemListBloc.add(ProducerCreated(player, existingResource, existingLocation, 1, 1));
          } : null,
          child: const Text("+Producer"),
        ),
        OutlinedButton(
          onPressed: canCreateStorage ? () {
            context.itemListBloc.add(StorageCreated(player, existingResource, existingLocation, 1000));
          } : null,
          child: const Text("+Storage"),
        ),
      ],
    );
  }

}

