import 'package:flutter/material.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/shared/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  final String title;
  final String body;
  final String image;

  OnBoardingModel({
    required this.title,
    required this.body,
    required this.image,
  });
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoardingModel> items = [
    OnBoardingModel(
        title: "Screen 1", body: "Screen Body 1", image: 'assets/images/1.png'),
    OnBoardingModel(
        title: "Screen 2", body: "Screen Body 2", image: 'assets/images/1.png'),
    OnBoardingModel(
        title: "Screen 3", body: "Screen Body 3", image: 'assets/images/1.png'),
  ];

  var pageController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              CacheHelper.saveData(key: "isBoarding", value: true).then((value){
                navigateAndFinish(context,LoginScreen());
                print(CacheHelper.getData(key: "isBoarding"));

              });


            },
            child: const Text("SKIP"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildOnBoardingItem(model: items[index]),
                itemCount: items.length,
                onPageChanged: (int index) {
                  if (index == items.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.deepOrange,
                    expansionFactor: 4.0,
                    spacing: 5,
                  ),
                  count: items.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      CacheHelper.saveData(key: "isBoarding", value: true).then((value){
                        navigateAndFinish(context,LoginScreen());
                      });
                    } else {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastOutSlowIn);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem({required OnBoardingModel model}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Image(
            image: AssetImage(model.image),
          )),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            model.body,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
}
