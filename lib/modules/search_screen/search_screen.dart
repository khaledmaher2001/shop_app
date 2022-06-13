import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';

import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search_screen/cubit/cubit.dart';
import 'package:shop_app/modules/search_screen/cubit/states.dart';
import 'package:shop_app/shared/cubit/cubit.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultTextFormField(
                    label: "Search",
                    controller: searchController,
                    prefixIcon: Icons.search,
                    validation: (String value) {
                      if (value.isEmpty) {
                        return "Search empty Enter search text";
                      }
                    },
                    type: TextInputType.text,
                    submit: (String text){
                      SearchCubit.get(context).search(text:text);
                    }

                  ),
                  const SizedBox(height: 10,),
                  if(state is SearchLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 10,),


                  if(state is SearchSuccessState)
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildFavItem(
                        SearchCubit.get(context).searchModel!.data!.data![index],
                        context,
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: SearchCubit.get(context).searchModel!.data!.data!.length,
                    ),
                  ),


                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildFavItem(ProductData model, context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: NetworkImage('${model.image}'),
          height: 100,
          width: 100,
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
                  // if (model.discount! > 0)
                  //   Text(
                  //     "${model.oldPrice!.round()} \$",
                  //     maxLines: 1,
                  //     style: const TextStyle(
                  //         color: Colors.grey,
                  //         decoration: TextDecoration.lineThrough),
                  //   ),
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
