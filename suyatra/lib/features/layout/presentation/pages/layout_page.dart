import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/features/account/presentation/pages/account_page.dart';
import 'package:suyatra/features/articles/presentation/pages/explore_page.dart';
import 'package:suyatra/features/home/presentation/pages/home_page.dart';
import 'package:suyatra/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:suyatra/widgets/page_loader.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LayoutCubit>(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          switch (state.layoutStatus) {
            case AppStatus.loading:
              return const PageLoader();
            default:
              return _layout(BlocProvider.of<LayoutCubit>(context));
          }
        }, 
      ),
    );
  }

  Widget _layout(LayoutCubit cubit) {
    return Scaffold(
      body: _body(cubit),
      bottomNavigationBar: _bottomNavBar(cubit),
    );
  }

  Widget _body(LayoutCubit cubit) {
    switch (cubit.state.currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ExplorePage();
      case 2:
        return const AccountPage();
      default:
        return const ExplorePage();
    }
  }

  Widget _bottomNavBar(LayoutCubit cubit) {
    return BottomNavigationBar(
      currentIndex: cubit.state.currentIndex,
      onTap: (int index) {
        cubit.changeBottomIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset("assets/images/primary_icon_unselected.png", height: 24.0, width: 24.0,),
          activeIcon: Image.asset("assets/images/primary_icon.png", height: 24.0, width: 24.0,),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: "Explore",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: "Account",
        )
      ],
    );
  }
}