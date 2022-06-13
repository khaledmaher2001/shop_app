import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: ConditionalBuilder(
          condition: state is! GetFavoritesDataLoadingState &&
              AppCubit.get(context).favoritesModel != null,
          builder: (context) => AppCubit.get(context)
                  .favoritesModel!
                  .data!
                  .data!
                  .isNotEmpty
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildFavItem(
                      AppCubit.get(context).favoritesModel!.data!.data![index].product,
                      context),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      AppCubit.get(context).favoritesModel!.data!.data!.length,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "No Favorite Products !",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
      },
    );
  }

  Widget buildFavItem(model, context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  height: 100,
                  width: 100,
                ),
                if (model.discount! > 0)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    color: Colors.red,
                    child: const Text(
                      "DISCOUNT",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "${model.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        "${model.price!.round()} \$",
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      if (model.discount! > 0)
                        Text(
                          "${model.oldPrice!.round()} \$",
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context)
                                .changeFavorites(model.id!);
                            // AppCubit.get(context).getFavoritesProducts();
                            print(model.id);
                          },
                          icon: CircleAvatar(
                            backgroundColor: AppCubit.get(context)
                                    .favorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                            radius: 15,
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
