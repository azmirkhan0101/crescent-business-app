import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/core/routes/route_path.dart';
import '../../utils/app_size.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<_NavItem> _items = [
    _NavItem(icon: Icons.home, route: RoutesPath.home),
    _NavItem(icon: Icons.bar_chart, route: RoutesPath.analytics),
    _NavItem(icon: Icons.qr_code_scanner, route: RoutesPath.redeemScanner),
    _NavItem(icon: Icons.star, route: RoutesPath.tabScreen),
    _NavItem(icon: Icons.person, route: RoutesPath.businessProfile),
  ];

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    return _items.indexWhere((item) => location.startsWith(item.route));
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.paddingLarge,
          right: AppSizes.paddingLarge,
          bottom: 30.h,
        ),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final bool selected = index == currentIndex;

              return GestureDetector(
                onTap: () {
                  if (!selected) {
                    context.go(_items[index].route);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: selected ? 56.h : 40.h,
                  width: selected ? 64.w : 40.w,
                  decoration: BoxDecoration(
                    color: selected ? Colors.purple : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    _items[index].icon,
                    size: 24.sp,
                    color: selected ? Colors.white : Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String route;

  _NavItem({required this.icon, required this.route});
}
