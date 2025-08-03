import 'package:equatable/equatable.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavoritesEvent extends FavoritesEvent {
  const FetchFavoritesEvent();
}

class AddToFavoritesEvent extends FavoritesEvent {
  final ActivityApiModel activity;

  const AddToFavoritesEvent(this.activity);

  @override
  List<Object?> get props => [activity];
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final String activityId;

  const RemoveFromFavoritesEvent(this.activityId);

  @override
  List<Object?> get props => [activityId];
}
