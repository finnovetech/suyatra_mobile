import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:suyatra/features/home/presentation/cubit/home_cubit.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/page_loader.dart';

import '../../../../services/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ActivityCubit activityCubit = BlocProvider.of<ActivityCubit>(context);
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          switch (state.homeStatus) {
            case AppStatus.loading:
              return const PageLoader();
            case AppStatus.success:
              return _body(BlocProvider.of<HomeCubit>(context), activityCubit);
            default:
              return _body(BlocProvider.of<HomeCubit>(context), activityCubit);
          }
        },
      ),
    );
  }

  Widget _body(HomeCubit cubit, ActivityCubit activityCubit) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Activities",
          style: TextStyle(
            fontSize: h6,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              locator<NavigationService>().navigateToAndBack(activityNotificationsRoute);
            },
            icon: const Icon(
              Icons.notifications, 
              color: lightGrey,
            ),
          )
        ],
      ),
      body: activityCubit.state.activities?.isNotEmpty == true 
        ? _activityList(activityCubit)
        : _noActivityWidget(),
    );
  }

  Widget _activityList(ActivityCubit activityCubit) {
    return Container();
  }

  Widget _noActivityWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 80.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "It's empty here...",
              style: TextStyle(
                fontSize: h8,
                fontWeight: FontWeight.w500,
                color: grey70,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Create your first activity now",
              style: TextStyle(
                fontSize: h6,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              fullWidth: false,
              elevation: 5,
              onPressed: () {
                
              },
              icon: const Icon(Icons.add),
              buttonColor: himalayanBlue,
              label: "create an activity",
            )
          ],
        ),
      ),
    );
  }
}
