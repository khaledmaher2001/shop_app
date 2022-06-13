import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login_screen/cubit/states.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
   LoginModel? loginModel;

  void changeVisibilityState() {
    isPassword = !isPassword;
    emit(ChangeVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        "email": email,
        "password": password,
      },
    ).then((value) {

      loginModel=LoginModel.fromJson(value.data);
      print(loginModel!.data!.token);
      emit(LoginSuccessState(loginModel!));

    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error));
    });
  }
  // void userLogin({
  //   required String email,
  //   required String password,
  // }) {
  //   emit(LoginLoadingState());
  //   DioHelper.postData(
  //     url: LOGIN,
  //     data: {
  //       "email": email,
  //       "password": password,
  //     },
  //   ).then((value) {
  //     loginModel=LoginModel.fromJson(value.data);
  //     emit(LoginSuccessState(loginModel!));
  //
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(LoginErrorState(error));
  //   });
  // }
}
