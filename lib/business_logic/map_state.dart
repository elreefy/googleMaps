part of 'map_cubit.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapLoaded extends MapState {

}
class MapError extends MapState {
  final String message;
  MapError(this.message);
}
class UserSignoutLoading extends MapState {}
class UserSignoutLoaded extends MapState {}
class SearchLoading extends MapState {}
class DirectionsLoading extends MapState {}
class DirectionsLoaded extends MapState {}
class DirectionsError extends MapState {
  final String message;
  DirectionsError(this.message);
}
class DetailsLoading extends MapState {}
class DetailsLoaded extends MapState {}
class DetailsError extends MapState {
  final String message;
  DetailsError(this.message);
}
class PlacesLoading extends MapState {}
class PlacesLoaded extends MapState {
  final List predictions;

  PlacesLoaded(this.predictions);
}
class SearchLoaded extends MapState {
  final PlacesModel searchResults;
  SearchLoaded(this.searchResults);}
