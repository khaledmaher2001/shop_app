import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/components/styles/theme.dart';
import 'package:shop_app/layout/layout_screen.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/modules/onboarding_screen/onboarding_screen.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/local/cache_helper.dart';
import 'package:shop_app/shared/remote/dio_helper.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await CacheHelper.init();
  bool? isBoarding = CacheHelper.getData(key: "isBoarding");
  token = CacheHelper.getData(key: 'token');
  print("token is:  $token");

  Widget? startScreen;
  if (isBoarding != null) {
    if (token != null) {
      startScreen = HomeScreen();
    } else {
      startScreen = LoginScreen();
    }
  } else {
    startScreen = OnBoardingScreen();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..getProducts()..getCategoryData()..getFavoritesProducts()..getUserData(),

      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: defaultTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
