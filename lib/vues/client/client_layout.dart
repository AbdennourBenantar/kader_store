import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaderstore/vues/client/navigation/client_navigation_bloc.dart';
import 'package:kaderstore/vues/client/sidebar_client.dart';


class ClientLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<ClientNavigationBloc>(
          create: (context)=>ClientNavigationBloc(),
          child: Stack(
            children: <Widget>[
              BlocBuilder<ClientNavigationBloc,ClientNavigationStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                },
              ),
              SideBarClient(),
            ],
          ),
        )
    );
  }
}
