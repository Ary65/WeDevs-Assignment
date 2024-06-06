import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:wedevs_assignment/features/home/screens/home_screen.dart';
import 'package:wedevs_assignment/features/profile/screens/profile_screen.dart';
import 'package:wedevs_assignment/features/constants/colors.dart';

final List<Widget> screens = [
  const HomeScreen(),
  const Center(
    child: Text('Categories'),
  ),
  const Center(
    child: Text('Search'),
  ),
  const Center(
    child: Text('Cart'),
  ),
  const ProfileScreen(),
];

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
    List<TabItem> items = [
      const TabItem(
        icon: Icons.home,
        title: 'Home',
      ),
      const TabItem(
        icon: Icons.category,
        title: 'Wishlist',
      ),
      const TabItem(
        icon: Icons.search,
        title: 'Search',
      ),
      const TabItem(
        icon: Icons.shopping_cart,
        title: 'Cart',
      ),
      const TabItem(
        icon: Icons.person,
        title: 'Profile',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: visit,
        children: screens,
      ),
      bottomNavigationBar: BottomBarInspiredOutside(
        items: items,
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        colorSelected: AppColors.whiteColor,
        indexSelected: visit,
        onTap: (int index) => setState(() {
          visit = index;
        }),
        top: -28,
        animated: false,
        itemStyle: ItemStyle.circle,
        chipStyle: const ChipStyle(
          notchSmoothness: NotchSmoothness.softEdge,
          background: AppColors.primaryColor,
        ),
      ),
    );
  }
}
