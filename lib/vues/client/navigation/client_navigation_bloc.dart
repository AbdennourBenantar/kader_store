
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaderstore/vues/client/client_history.dart';
import 'package:kaderstore/vues/client/client_home_page.dart';
import 'package:kaderstore/vues/client/client_panier.dart';

enum ClientNavigationEvents{
  MainPageClickedEvent,
  PanierClickedEvent,
  HistoryClickedEvent
}

abstract class ClientNavigationStates{}

class ClientNavigationBloc extends Bloc<ClientNavigationEvents,ClientNavigationStates>{
  @override
  ClientNavigationStates get initialState =>  ClientHomePage();

  @override
  Stream<ClientNavigationStates> mapEventToState(ClientNavigationEvents event) async* {
    switch(event){
      case ClientNavigationEvents.MainPageClickedEvent: yield ClientHomePage();
      break;
      case ClientNavigationEvents.PanierClickedEvent: yield Cart();
      break;
      case ClientNavigationEvents.HistoryClickedEvent: yield ClientHistory();
      break;
    }
  }

}