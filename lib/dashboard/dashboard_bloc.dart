import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/models/global_stats.dart';
import 'package:ftvirus/repositories/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class FetchDashboard extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class RefreshDashboard extends DashboardEvent {
  @override
  List<Object> get props => [];
}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardEmpty extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final GlobalStats currentData;

  DashboardLoaded({@required this.currentData});

  @override
  List<Object> get props => [currentData];
}

class DashboardError extends DashboardState {}


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiRepository apiRepository; 

  DashboardBloc({@required this.apiRepository}) : assert(apiRepository != null);
  @override
  DashboardState get initialState => DashboardEmpty();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is FetchDashboard) {
      yield* _mapFetchDashboardToState(event);
    } else if (event is RefreshDashboard) {
      yield* _mapRefreshDashboardToState(event);
    } 
  }

  Stream<DashboardState> _mapFetchDashboardToState(FetchDashboard event) async* {
    yield DashboardLoading();
    try {
      final allData = await apiRepository.getAllCountryData();
      
      yield DashboardLoaded(currentData: allData);

    } catch (e) {
      print(e);
      yield DashboardError();
    }
  }

  Stream<DashboardState> _mapRefreshDashboardToState(RefreshDashboard event) async* {
    try {
      // final DashboardModel DashboardModel = await apiRepository.getAllDashboards();
      // yield DashboardLoaded(DashboardModel: DashboardModel);
    } catch (_) {
      yield state;
    }
  }

}
