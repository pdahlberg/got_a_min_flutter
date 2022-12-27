
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_bloc.dart';

extension BuildContextExtensions on BuildContext {
  ItemListBloc get itemListBloc => read();
  ItemDetailsBloc get itemDetailsBloc => read();
}