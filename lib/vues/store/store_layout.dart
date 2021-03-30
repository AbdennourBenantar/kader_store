import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaderstore/vues/store/sidebar_store.dart';

import 'navigation/store_navigation_bloc.dart';

class StoreLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<NavigationBloc>(
          create: (context)=>NavigationBloc(),
          child: Stack(
            children: <Widget>[
              BlocBuilder<NavigationBloc,StoreNavigationStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                },
              ),
              SideBar(),
            ],
          ),
        )
    );
  }
}
