import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register_screen/cubit/states.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';
import 'package:shop_app/shared/remote/end_points.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  LoginModel? registerModel;

  void changeVisibilityState() {
    isPassword = !isPassword;
    emit(ChangeVisibilityState());
  }

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      },
    ).then((value) {

      registerModel=LoginModel.fromJson(value.data);
      print(registerModel!.data!.token);
      emit(RegisterSuccessState(registerModel!));

    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error));
    });
  }
}
