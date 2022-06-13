import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/layout/layout_screen.dart';
import 'package:shop_app/modules/login_screen/cubit/cubit.dart';
import 'package:shop_app/modules/login_screen/cubit/states.dart';
import 'package:shop_app/modules/products_screen/products_screen.dart';
import 'package:shop_app/modules/register_screen/register_screen.dart';
import 'package:shop_app/shared/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.model.status!) {
              print(state.model.message);
              CacheHelper.saveData(key: 'token', value: state.model.data!.token)
                  .then((value) {
                token = state.model.data!.token;
                navigateTo(context, HomeScreen());
              });

              Fluttertoast.showToast(
                  msg: state.model.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              print(state.model.message);

              Fluttertoast.showToast(
                  msg: state.model.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGIN",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login Now To Show Hot Offers",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        defaultTextFormField(
                          validation: (String value) {
                            if (value.isEmpty) {
                              return 'Email must not be empty';
                            }
                          },
                          type: TextInputType.emailAddress,
                          label: "Email",
                          prefixIcon: Icons.email_outlined,
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                            validation: (String value) {
                              if (value.isEmpty) {
                                return 'Password must not be empty';
                              }
                            },
                            type: TextInputType.visiblePassword,
                            label: "Password",
                            prefixIcon: Icons.lock_outline,
                            controller: passwordController,
                            isPassword: cubit.isPassword,
                            suffixIcon: cubit.isPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixPressed: () {
                              cubit.changeVisibilityState();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        state is LoginLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : defaultButton(
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: "login",
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don\'t have an account ?",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text("Register"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
