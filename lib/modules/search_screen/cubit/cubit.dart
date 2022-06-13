
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search_screen/cubit/states.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel? searchModel;

  void search({
    required String text,
  }) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {

      searchModel=SearchModel.fromJson(value.data);
      print(searchModel!.data!.data![0].name);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
