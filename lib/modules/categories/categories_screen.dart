import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class CateogriesScreen extends StatelessWidget {
  const CateogriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: ConditionalBuilder(
          condition: AppCubit.get(context).categoryModel != null,
          builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Image(
                          height: 120,
                          width: 120,
                          image: NetworkImage(
                              "${AppCubit.get(context).categoryModel!.data!.data![index].image}"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${AppCubit.get(context).categoryModel!.data!.data![index].name}",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount:
                  AppCubit.get(context).categoryModel!.data!.data!.length),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
      },
    );
  }
}
