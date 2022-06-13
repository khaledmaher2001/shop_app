import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/local/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        nameController.text = cubit.userData!.data!.name!;
        emailController.text = cubit.userData!.data!.email!;
        phoneController.text = cubit.userData!.data!.phone!;
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: state is! GetUserDataLoadingState
              ? Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is UpdateUserDataLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 20),
                      defaultTextFormField(
                        label: "Name",
                        controller: nameController,
                        prefixIcon: Icons.person,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Must Not Be Empty";
                          }
                        },
                        type: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        label: "Phone",
                        controller: phoneController,
                        prefixIcon: Icons.phone,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Must Not Be Empty";
                          }
                        },
                        type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        label: "Email",
                        controller: emailController,
                        prefixIcon: Icons.email_outlined,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Must Not Be Empty";
                          }
                        },
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultButton(
                        text: "log out",
                        press: () {
                          CacheHelper.removeData(key: 'token').then((value) {
                            if (value) {
                              // token = CacheHelper.getData(key: 'token');
                              navigateAndFinish(context, LoginScreen());
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultButton(
                        text: "update",
                        press: () {
                          if (formKey.currentState!.validate()) {
                            AppCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
      },
    );
  }
}
