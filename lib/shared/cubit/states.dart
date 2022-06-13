import 'package:shop_app/models/categiory_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';

abstract class AppStates {}

class InitAppState extends AppStates {}

class ChangeNavBarState extends AppStates {}

class GetProductsDataLoadingState extends AppStates {}

class GetProductsDataSuccessState extends AppStates {
  final HomeModel model;

  GetProductsDataSuccessState(this.model);
}

class GetProductsDataErrorState extends AppStates {}

class GetCategoryDataLoadingState extends AppStates {}

class GetCategoryDataSuccessState extends AppStates {
  final CategoryModel model;

  GetCategoryDataSuccessState(this.model);
}

class GetCategoryDataErrorState extends AppStates {}
class GetFavoritesDataLoadingState extends AppStates {}

class GetFavoritesDataSuccessState extends AppStates {
  final FavoritesModel model;

  GetFavoritesDataSuccessState(this.model);
}

class GetFavoritesDataErrorState extends AppStates {}

class ChangeFavoritesDataSuccessState extends AppStates {
  final ChangeFavoritesModel model;

  ChangeFavoritesDataSuccessState(this.model);
}

class ChangeFavoritesDataErrorState extends AppStates {}

class ChangeFavIcon extends AppStates {}
class GetUserDataLoadingState extends AppStates {}
class GetUserDataSuccessState extends AppStates {}
class GetUserDataErrorState extends AppStates {}
class UpdateUserDataLoadingState extends AppStates {}
class UpdateUserDataSuccessState extends AppStates {}
class UpdateUserDataErrorState extends AppStates {}
