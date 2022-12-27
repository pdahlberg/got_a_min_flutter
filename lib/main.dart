import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/infra/app_router.dart';
import 'package:got_a_min_flutter/infra/dependencies.dart';

void main() {
  runApp(const ProductionEnvironment());
}

class ProductionEnvironment extends StatelessWidget {

  const ProductionEnvironment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ...Dependencies.common(),
        ...Dependencies.prod(),
      ],
      child: MultiBlocProvider(
        providers: [
          ...Dependencies.blocs(),
        ],
        child: App(),
      ),
    );
  }

}

class App extends StatelessWidget {
  // make sure you don't initiate your router
  // inside of the build function.
  final _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
