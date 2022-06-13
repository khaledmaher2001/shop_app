import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/models/categiory_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favoriets_screen/favoriets_screen.dart';
import 'package:shop_app/modules/products_screen/products_screen.dart';
import 'package:shop_app/modules/settings_screen/settings_screen.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';
// import 'package:shop_app/shared/remote/end_points.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitAppState());

  static AppCubit get(context) => BlocProvider.of(context);
  List banners = [];
  HomeModel? productModel;
  CategoryModel? categoryModel;
  FavoritesModel? favoritesModel;
  LoginModel? userData;
  bool isFav = false;
  Color iconColor = Colors.grey;
  Map<int, bool> favorites = {};
  ChangeFavoritesModel? changeFavoritesModel;

  int currentIndex = 0;
  List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: "Categories"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: "Favorites"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: "Settings"),
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  List<Widget> screens = [
    ProductsScreen(),
    CateogriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void getProducts() {
    emit(GetProductsDataLoadingState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      productModel = HomeModel.fromJson(value.data);

      for (var element in productModel!.data!.products!) {
        favorites.addAll({element.id!: element.inFavorites!});
      }

      print(favorites.toString());
      emit(GetProductsDataSuccessState(productModel!));
    }).catchError((error) {
      print(error.toString());
      emit(GetProductsDataErrorState());
    });
  }

  void getCategoryData() {
    emit(GetCategoryDataLoadingState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);

      emit(GetCategoryDataSuccessState(categoryModel!));
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoryDataErrorState());
    });
  }

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavIcon());
    DioHelper.postData(
      url: FAVORITES,
      token: token,
      data: {
        "product_id": productId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesProducts();
      }
      emit(ChangeFavoritesDataSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      emit(ChangeFavoritesDataErrorState());
    });
  }

  void getFavoritesProducts() {
    emit(GetFavoritesDataLoadingState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(GetFavoritesDataSuccessState(favoritesModel!));
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesDataErrorState());
    });
  }

  void getUserData() {
    emit(GetUserDataLoadingState());
    DioHelper.getData(
      url: PROFIILE,
      token: token,
    ).then((value) {
      userData = LoginModel.fromJson(value.data);

      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
}) {
    emit(UpdateUserDataLoadingState());

    DioHelper.putData(
      url: UPDATE_PROFIILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userData=LoginModel.fromJson(value.data);
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
    });
  }
}
