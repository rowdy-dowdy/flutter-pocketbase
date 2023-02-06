import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String? oldLocation = 'chat';
List<String> bottomMenuName = ["contacts", "chat", "chat-detail", "settings", "setting-edit"];

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context, 
  required GoRouterState state, 
  required Widget child,
}) {

  int indexOldLocation = bottomMenuName.indexWhere((element) => element == oldLocation);
  int indexLocation = bottomMenuName.indexWhere((element) => element == state.name);

  double beginOffset = (indexOldLocation < indexLocation) ? 1.0 : -1.0;
  oldLocation = state.name;
  
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final begin = Offset(beginOffset, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child
        ),
      );
      // return FadeTransition(opacity: animation, child: child);
    } 
  );
}