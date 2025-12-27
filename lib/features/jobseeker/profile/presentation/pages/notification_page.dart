import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/competition_result.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';
import 'package:trajectoria/main.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with RouteAware {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<ProfileCubit>().getAnnouncements();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // List<String> localList = [];
  // Future<void> _refecthNotification() async {
  //   final allData = context.read<HydratedAnnouncement>().getAllAnnouncements();
  //   setState(() {
  //     localList = allData;
  //   });
  //   await context.read<ProfileCubit>().getAnnouncements();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: AppColors.splashBackground,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileCubit>().getAnnouncements();
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, announcementState) {
            if (announcementState is AnnouncementsLoaded) {
              final announcements = announcementState.announcements;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                padding: const EdgeInsets.all(16.0),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return notificationCard(context, announcements[index]);
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget notificationCard(BuildContext context, AnnouncementEntity item) {
    //formatter date
    final formatter = DateFormat('d MMM y', 'id_ID');
    final formattedDateComplete = formatter.format(
      item.createdAnnouncementAt!.toDate(),
    );

    return InkWell(
      onTap: () {
        // context.read<HydratedAnnouncement>().deleteAnnouncementId(
        //   item.announcementId!,
        // );
        context.read<ProfileCubit>().markasDoneNotification(
          item.announcementId!,
        );
        AppNavigator.push(
          context,
          CompetitionResultPage(
            competitionId: item.competitionId,
            submissionId: item.submissionId,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.thirdBackGroundButton),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.competitionName,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDateComplete,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Hai sobat trajectoria, ada pengumuman terbaru nih dari ${item.competitionName} ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "klik untuk cek hasil pengerjaan mu ya",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () async {
                await context.read<ProfileCubit>().deleteAnnouncement(
                  item.announcementId!,
                );
              },
              icon: Icon(CupertinoIcons.trash, size: 20, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
