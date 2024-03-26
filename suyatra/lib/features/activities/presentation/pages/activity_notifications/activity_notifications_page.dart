import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';

class ActivityNotificationsPage extends StatelessWidget {
  const ActivityNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ActivityCubit activityCubit = BlocProvider.of<ActivityCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Activity"),
        actionsIconTheme: const IconThemeData(
          color: lightGrey,
          size: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.more_vert_sharp,
            ),
          ),
          IconButton(
            onPressed: () {
              locator<NavigationService>().navigateToAndBack(activityNotificationSettingsRoute);
            }, 
            icon: const Icon(
              Icons.settings_outlined,
            ),
          )
        ],
      ),
      body: activityCubit.state.activityNotifications?.isNotEmpty == true 
        ? _activityNotificationsList(activityCubit)
        : _noActivityNotification() 
    );
  }

  Widget _activityNotificationsList(ActivityCubit activityCubit) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: activityCubit.state.activityNotifications?.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          
        );
      }
    );
  }

  Widget _noActivityNotification() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty_notification.png"),
          const SizedBox(height: 16.0),
          const Text(
            "No any activity yet!",
            style: TextStyle(
              fontSize: h9,
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            "Initiate a conversation with an expert by tapping their profile icon in the Explore section or by tapping the 'Add chat' button below.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}