import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/screens/provider_screens/subscription_screen.dart';
import 'package:mycar/screens/stepper_screen.dart';
import 'models/chat.dart';
import 'screens/customer_screens/customer_cars_screen.dart';
import 'screens/customer_screens/customer_chat.dart';
import 'screens/customer_screens/customer_favorites.dart';
import 'screens/customer_screens/customer_home.dart';
import 'screens/customer_screens/customer_my_order_screen.dart';
import 'screens/shared/auth_wrapper.dart';
import 'screens/shared/notifications_screen.dart';
import 'screens/customer_screens/customer_profile_screen.dart';
import 'screens/customer_screens/service_screen.dart';
import 'screens/customer_wrapper.dart';
import 'screens/provider_screens/provider_car_companies_screen.dart';
import 'screens/provider_screens/provider_home_screen.dart';
import 'screens/provider_screens/provider_profile_screen.dart';
import 'screens/provider_screens/provider_store_screen.dart';
import 'screens/provider_wrapper.dart';
import 'screens/shared/chat_screen.dart';
import 'screens/shared/forgot_password_screen.dart';
import 'screens/shared/login_screen.dart';
import 'screens/shared/new_ticket_screen.dart';
import 'screens/shared/privacy_policy_screen.dart';
import 'screens/shared/support_screen.dart';
import 'screens/shared/terms_of_use_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/page_animation.dart';

final routerNavigator = GlobalKey<NavigatorState>(debugLabel: 'Router');

enum AppRoutes {
  privacyPolicy,
  termsOfUse,
  success,
  support,
  supportTicket,
  providerHome,
  chat,
  carCompanies,
  store,
  profile,
  orderDetails,
  customerCars,
  customerAddNewCar,
  customerSpareParts,
  customerProfile,
  customerHome,
  serviceScreen,
  carMaintenance,
  flatbedServices,
  flatbedOrderDetails,
  sparePartsService,
  carMaintenanceChooseCarPart,
  carPartsServiceProviders,
  carPartsOrders,
  carMaintenanceChooseEngineer,
  carMaintenanceOrderDetails,
  login,
  register,
  forgetPassword,
  forgetPasswordOtp,
  resetPassword,
  subscription,
}

final GoRouter router = GoRouter(
  navigatorKey: routerNavigator,
  initialLocation: "/",
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/stepper',
      builder: (BuildContext context, GoRouterState state) {
        return const StepperScreen();
      },
    ),
    GoRoute(
      path: '/login',
      name: AppRoutes.login.name,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      name: AppRoutes.register.name,
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: '/subscription',
      name: AppRoutes.subscription.name,
      builder: (BuildContext context, GoRouterState state) {
        return const SubscriptionScreen();
      },
    ),
    GoRoute(
      path: '/forget-password',
      name: AppRoutes.forgetPassword.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/service-screen',
      name: AppRoutes.serviceScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return ServiceScreen(
          serviceData: state.extra as ServiceScreenData,
        );
      },
    ),
    GoRoute(
      path: '/customer-cars',
      name: AppRoutes.customerCars.name,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomerCarsScreen();
      },
    ),
    GoRoute(
      path: '/customer-profile',
      name: AppRoutes.customerProfile.name,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomerProfileScreen();
      },
    ),
    ShellRoute(
      pageBuilder: (context, state, child) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: CustomerWrapper(
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 120),
          reverseTransitionDuration: const Duration(milliseconds: 120),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              PageAnimation(
            context: context,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/customer-home',
          name: AppRoutes.customerHome.name,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerHome();
          },
        ),
GoRoute(
  path: '/customer-chat',
  builder: (BuildContext context, GoRouterState state) {
    final int initialIndex = state.extra is int ? state.extra as int : 0;
    return CustomerChat(initialIndex: initialIndex);
  },
),
        GoRoute(
          path: '/customer-orders',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthWrapper(child: CustomerMyOrderScreen(),);
          },
        ),
        GoRoute(
          path: '/customer-favorites',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthWrapper(child: CustomerFavorites(),);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/notifcations',
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationsScreen();
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) {
        return ChatScreen(
          chat: state.extra as Chat,
        );
      },
    ),
    GoRoute(
      path: '/customers-support',
      name: AppRoutes.support.name,
      builder: (BuildContext context, GoRouterState state) {
        return const SupportScreen();
      },
      routes: [
        GoRoute(
          path: '/new-ticket',
          name: AppRoutes.supportTicket.name,
          builder: (BuildContext context, GoRouterState state) {
            return const NewTicketScreen();
          },
        )
      ],
    ),
    GoRoute(
      path: '/privacy-policy',
      name: AppRoutes.privacyPolicy.name,
      builder: (context, state) {
        return const PrivacyPolicyScreen();
      },
    ),
    GoRoute(
      path: '/terms-of-use',
      name: AppRoutes.termsOfUse.name,
      builder: (context, state) {
        return const TermsOfUseScreen();
      },
    ),
    ShellRoute(
      pageBuilder: (context, state, child) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: ProviderWrapper(
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 120),
          reverseTransitionDuration: const Duration(milliseconds: 120),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              PageAnimation(
            context: context,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/provider-home',
          name: AppRoutes.providerHome.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProviderHomeScreen();
          },
        ),
GoRoute(
  path: '/provider-chat',
  name: AppRoutes.chat.name,
  builder: (BuildContext context, GoRouterState state) {
    final int initialIndex = state.extra is int ? state.extra as int : 0;
    return CustomerChat(initialIndex: initialIndex);
  },
),
        GoRoute(
          path: '/provider-car-companies',
          name: AppRoutes.carCompanies.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProviderCarCompaniesScreen();
          },
        ),
        GoRoute(
          path: '/provider-store',
          name: AppRoutes.store.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProviderStoreScreen();
          },
        ),
        GoRoute(
          path: '/provider-profile',
          name: AppRoutes.profile.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProviderProfileScreen();
          },
        ),
      ],
    ),
  ],
);
