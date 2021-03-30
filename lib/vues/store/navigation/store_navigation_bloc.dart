
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaderstore/vues/store/store_commandes.dart';
import 'package:kaderstore/vues/store/store_home_page.dart';
import 'package:kaderstore/vues/store/store_products.dart';

enum StoreNavigationEvents{
  MainPageClickedEvent,
  ProductsClickedEvent,
  CommandesClickedEvent,
  SettingsClickedEvent,
}

abstract class StoreNavigationStates{}

class NavigationBloc extends Bloc<StoreNavigationEvents,StoreNavigationStates>{
  @override
  StoreNavigationStates get initialState =>  StoreHomePage();

  @override
  Stream<StoreNavigationStates> mapEventToState(StoreNavigationEvents event) async* {
    switch(event){
      case StoreNavigationEvents.MainPageClickedEvent: yield StoreHomePage();
      break;
      case StoreNavigationEvents.ProductsClickedEvent: yield StoreProducts();
      break;
      case StoreNavigationEvents.CommandesClickedEvent: yield Commandes();
      break;
      case StoreNavigationEvents.SettingsClickedEvent: yield StoreHomePage();
      break;
    }
  }

}