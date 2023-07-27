import 'package:flutter/material.dart';

class NoWifiScreen extends StatelessWidget {
  const NoWifiScreen({
    Key? key,
    required this.onButtonPressed,
  }) : super(key: key);

  final GestureTapCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 180,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: 16),
          Text(
            "No Internet Connection",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall,
          ),
          Text(
            "Please check your internet settings",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge,
          ),
          SizedBox(height: 8),
          Text(
            "and try again",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge,
          ),
          SizedBox(height: 48),
          SizedBox(
            width: 200.0,
            height: 100.0,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              child: Text('Retry',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall
              ),
            ),
          ),
        ],
      ),
    );
  }
}
