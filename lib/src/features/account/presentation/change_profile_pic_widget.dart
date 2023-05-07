import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/colors.dart';

class ChangeProfilPic extends StatelessWidget {
  final void Function() onTap;
  const ChangeProfilPic({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 6,
        right: 6,
        child: CircleAvatar(
          backgroundColor: buttonColor,
          radius: 25,
          child: IconButton(
            color: Colors.white,
            splashRadius: 20,
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              onTap();
            },
          ),
        ));
  }
}
