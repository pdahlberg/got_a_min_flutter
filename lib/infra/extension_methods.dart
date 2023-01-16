
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/player_bloc.dart';
import 'package:solana/solana.dart';

extension BuildContextExtensions on BuildContext {
  ItemListBloc get itemListBloc => read();
  ItemDetailsBloc get itemDetailsBloc => read();
  PlayerBloc get playerBloc => read();
}

extension CompactPrint on Ed25519HDPublicKey {
  String toShortString() {
    var base58 = toBase58();
    final first = base58.substring(0, 4);
    final last = base58.substring(base58.length - 4);
    return "$first...$last";
  }
}