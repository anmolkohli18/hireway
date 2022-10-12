import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showOverlay<T>(
    String successText,
    BuildContext context,
    AnimationController? animationController,
    Animation<double>? animation,
    StateProvider<T> provider,
    T acceptedState,
    WidgetRef ref) async {
  if (ref.watch(provider.state).state == acceptedState) {
    OverlayState? overlayState = Overlay.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    OverlayEntry successOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: screenWidth / 2,
            top: 90,
            child: FadeTransition(
              opacity: animation!,
              child: Card(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.check_box,
                          color: Colors.green.shade600,
                        ),
                        Text(
                          successText,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        const Icon(
                          Icons.close_outlined,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
    overlayState!.insert(successOverlayEntry);
    animationController!.forward();
    await Future.delayed(const Duration(seconds: 3));
    animationController!.reverse();
    successOverlayEntry.remove();
  }
}
