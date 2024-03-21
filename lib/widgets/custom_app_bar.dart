import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import 'app_toolbar_logout.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: const AppToolbarLogout(
        sectionName: 'Germanen-App',
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}
