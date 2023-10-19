import 'package:doctor/view/bottom_nav/bottom_nav_screen.dart';
import 'package:doctor/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'logic/bloc/cubit.dart';
import 'constants/colors.dart';
import 'network/local/bloc_observer.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  runApp(
    const MyApp(
      startWidget: LoginScreen(),
    ),
  );

}

class MyApp extends StatefulWidget {
  final Widget? startWidget;

  const MyApp({super.key, this.startWidget});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // late Locale _appLocale;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(defaultColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: defaultColor),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: widget.startWidget,
        home: const AppLayout(),
      ),
    );
  }
}
