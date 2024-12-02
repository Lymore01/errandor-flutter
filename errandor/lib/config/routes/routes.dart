import "package:errandor/presentation/screens/dashboard.dart";
import "package:errandor/presentation/screens/login.dart";
import "package:errandor/presentation/screens/register.dart";
import "package:get/get.dart";

var transition = Transition.fadeIn;
var routes = [
  GetPage(name: "/login", page: () => const Login(), transition: transition),
  GetPage(name: "/register", page: () => const Register(), transition: transition),
  GetPage(name: "/", page: () => const Dashboard(), transition: transition),
];
