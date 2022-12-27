import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/domain/view/item_details_page.dart';
import 'package:got_a_min_flutter/domain/view/item_list_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: ItemListPage,
      initial: true,
      path: "/items",
    ),
    AutoRoute(
        page: ItemDetailsPage,
        path: "/items/:address",
    ),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter{}


