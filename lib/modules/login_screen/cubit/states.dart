import 'package:shop_app/models/login_model.dart';

abstract class LoginStates{}
class InitialLoginState extends LoginStates{}
class ChangeVisibilityState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final LoginModel model;

  LoginSuccessState(this.model);
}
class LoginLoadingState extends LoginStates{}
class LoginErrorState extends LoginStates{
  final  LoginModel error;

  LoginErrorState(this.error);
}