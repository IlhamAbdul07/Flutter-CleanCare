import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/main_controller.dart';
import 'package:flutter_cleancare/core/theme/size_config.dart';
import 'package:flutter_cleancare/pages/admin_home_page.dart';
import 'package:flutter_cleancare/pages/admin_profile_page.dart';
import 'package:flutter_cleancare/pages/staff_home_page.dart';
import 'package:flutter_cleancare/pages/staff_profile_page.dart';
import 'package:flutter_cleancare/pages/user_management_page.dart';
import 'package:flutter_cleancare/widgets/appbar_widget.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final mainC = Get.find<MainController>();

    // Create lists of pages for each role
    final adminPages = <Widget>[
      const AdminHomePage(),
      const UserManagementPage(),
      const AdminProfilePage(),
    ];

    final staffPages = <Widget>[
      const StaffHomePage(),
      const StaffProfilePage(),
    ];

    return Obx(() {
      // If no user loaded (shouldn't happen normally), show a fallback
      final currentUser = authC.currentUser.value;
      if (currentUser == null) {
        return const Scaffold(body: Center(child: Text('No user.')));
      }

      final pages = authC.isAdmin ? adminPages : staffPages;

      // Build BottomNavigationBar items depending on role
      final items = authC.isAdmin
          ? const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]
          : const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ];

      // Make sure current index isn't out of range (role switch edge case)
      if (mainC.index.value >= pages.length) {
        mainC.setIndex(0);
      }

      return Scaffold(
        appBar: AppbarWidget(),
        body: Obx(() {
          final currentPageIndex = mainC.index.value;

          if (authC.isAdmin) {
            switch (currentPageIndex) {
              case 0:
                return const AdminHomePage();
              case 1:
                return const UserManagementPage();
              case 2:
                return const AdminProfilePage();
              default:
                return const AdminHomePage();
            }
          } else {
            switch (currentPageIndex) {
              case 0:
                return const StaffHomePage();
              case 1:
                return const StaffProfilePage();
              default:
                return const StaffHomePage();
            }
          }
        }),
        bottomNavigationBar: Builder(
          builder: (context) {
            SizeConfig.init(context);

            final iconSize = (SizeConfig.width * 0.1).clamp(22.0, 32.0);
            final fontSize = (SizeConfig.width * 0.1).clamp(10.0, 14.0);

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(
                () => BottomNavigationBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: mainC.index.value,
                  onTap: (i) => mainC.setIndex(i),
                  type: BottomNavigationBarType.fixed,
                  iconSize: iconSize,
                  selectedFontSize: fontSize,
                  unselectedFontSize: fontSize,
                  items: items,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
