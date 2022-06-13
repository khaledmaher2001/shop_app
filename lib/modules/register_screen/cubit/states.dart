import 'package:shop_app/models/login_model.dart';

abstract class RegisterStates{}
class InitialRegisterState extends RegisterStates{}
class ChangeVisibilityState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{
  final LoginModel model;

  RegisterSuccessState(this.model);
}
class RegisterLoadingState extends RegisterStates{}
class RegisterErrorState extends RegisterStates{
  final String error;

  RegisterErrorState(this.error);
}