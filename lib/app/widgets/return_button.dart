import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            // customBorder: CircleBorder(),
            padding: EdgeInsets.zero,
            splashRadius: 50,
            icon: const Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 35,
              ),
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
      ),
    );
  }
}
