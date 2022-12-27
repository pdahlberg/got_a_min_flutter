

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class ItemDetailsPage extends StatelessWidget implements AutoRouteWrapper {

  final String address;

  const ItemDetailsPage({
    super.key,
    @PathParam('address') required this.address,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    debugPrint("[wrappedRoute] context.itemDetailsBloc.state => ${context.itemDetailsBloc.state}");
    debugPrint("[wrappedRoute] ItemDetailsPage.address => $address");

    if(context.itemDetailsBloc.stateSyncNeeded(address: address)) {
      context.itemDetailsBloc.add(ItemAddressAskedFor(address));
      debugPrint("[wrappedRoute] sync state attempt");
    }

    return this;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ItemDetailsState -> build: ${address} (before)");

    return BlocListener<ItemDetailsBloc, ItemDetailsState>(
      listener: (context, state) {
        debugPrint("ItemDetailsState -> build: ${address} (inside listener)");
        debugPrint("ItemDetailsState -> state: ${state.item.id} (listener)");
      },
      child: BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
        builder: (context, state) {
          debugPrint("ItemDetailsState -> build: ${address} (inside builder)");
          debugPrint("ItemDetailsState -> state: ${state.item.id} (builder)");

          if(state.isError) {
            return Text(state.getErrorMsg());
          } else if(state.item.id.keyPair == null || address != state.item.id.publicKey.toBase58()) {
            return const CircularProgressIndicator();
          } else {
            return ItemDetailsBody(
              item: state.item,
            );
          }
        },
      ),
    );
  }

}

class ItemDetailsBody extends StatelessWidget {

  final Item item;

  const ItemDetailsBody({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.id.publicKey.toBase58()),
            Text(item.name),
            const Text("..."),
            Text("~${item.timestamp}~"),
            Row(
              children: [
                TextButton(
                  onPressed: item.initialized ? null : () => context.itemDetailsBloc.add(ItemInitialized(item)),
                  child: const Text("Init"),
                ),
                TextButton(
                  onPressed: item.initialized ? () {} : null,
                  child: const Text("Something else"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
