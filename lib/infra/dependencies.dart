

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/adapter/solana/solana_service_impl.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/producer_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/storage_repository.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';


class Dependencies {

  static List<RepositoryProvider> common() => [
    RepositoryProvider<TimeService>(create: (_) => TimeService()),
    RepositoryProvider<ItemRepository>(create: (context) {
      final repository = ItemRepository.of(context);

      /*["one", "two", "hundred"]
          .map((name) async => await Item.from)
          .forEach(repository.save);*/

      return repository;
    }),
    RepositoryProvider<ProducerRepository>(create: ProducerRepository.of),
    RepositoryProvider<StorageRepository>(create: StorageRepository.of),
    RepositoryProvider<SolanaServicePort>(create: SolanaServiceImpl.of),
  ];

  static List<BlocProvider> blocs() => [
    BlocProvider<ItemListBloc>(create: (context) => ItemListBloc.of(context)
      ..add(ItemListRefreshed())
    ),
    const BlocProvider<ItemDetailsBloc>(create: ItemDetailsBloc.of),
  ];

  static List<RepositoryProvider> prod() => [
  ];

}
