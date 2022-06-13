import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/models/categiory_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is ChangeFavoritesDataSuccessState){
          if(!state.model.status!){
            Fluttertoast.showToast(
                msg: state.model.message!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: ConditionalBuilder(
            condition: cubit.productModel != null&&cubit.categoryModel!=null,
            builder: (context) => productsBuilder(
                cubit.productModel!, cubit.categoryModel!, context),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoryModel categoryModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners!
                  .map((e) => Image(
                        image: NetworkImage('${e.image}'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          categoryItem(categoryModel, index),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemCount: categoryModel.data!.data!.length,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "New Products",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.count(

                    crossAxisCount: 2,

                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1.4,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    children: List.generate(
                      model.data!.products!.length,
                      (index) => buildProductItem(model.data!.products![index], index,context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget categoryItem(CategoryModel model, int index) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image(
              image: NetworkImage("${model.data!.data![index].image}"),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 25,
            width: 100,
            color: Colors.black.withOpacity(0.5),
            child: Text(
              "${model.data!.data![index].name}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      );

  Widget buildProductItem(Products model, int index,context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image(
              image: NetworkImage('${model.image}'),
              height: 150,
              width: double.infinity,
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
        Text(
          "${model.name}",
          style:const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,

        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "${model.price.round()} \$",
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            if (model.discount! > 0)
              Text(
                "${model.oldPrice.round()} \$",
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough),
              ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).changeFavorites(model.id!);
                  print(model.id);
                },
                icon:   CircleAvatar(
                  backgroundColor: AppCubit.get(context).favorites[model.id]!?defaultColor:Colors.grey,
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
  );
}
