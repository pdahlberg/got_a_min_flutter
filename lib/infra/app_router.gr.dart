// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    ItemListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ItemListPage(),
      );
    },
    ItemDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ItemDetailsRouteArgs>(
          orElse: () =>
              ItemDetailsRouteArgs(address: pathParams.getString('address')));
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: ItemDetailsPage(
          key: args.key,
          address: args.address,
        )),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/items',
          fullMatch: true,
        ),
        RouteConfig(
          ItemListRoute.name,
          path: '/items',
        ),
        RouteConfig(
          ItemDetailsRoute.name,
          path: '/items/:address',
        ),
      ];
}

/// generated route for
/// [ItemListPage]
class ItemListRoute extends PageRouteInfo<void> {
  const ItemListRoute()
      : super(
          ItemListRoute.name,
          path: '/items',
        );

  static const String name = 'ItemListRoute';
}

/// generated route for
/// [ItemDetailsPage]
class ItemDetailsRoute extends PageRouteInfo<ItemDetailsRouteArgs> {
  ItemDetailsRoute({
    Key? key,
    required String address,
  }) : super(
          ItemDetailsRoute.name,
          path: '/items/:address',
          args: ItemDetailsRouteArgs(
            key: key,
            address: address,
          ),
          rawPathParams: {'address': address},
        );

  static const String name = 'ItemDetailsRoute';
}

class ItemDetailsRouteArgs {
  const ItemDetailsRouteArgs({
    this.key,
    required this.address,
  });

  final Key? key;

  final String address;

  @override
  String toString() {
    return 'ItemDetailsRouteArgs{key: $key, address: $address}';
  }
}
