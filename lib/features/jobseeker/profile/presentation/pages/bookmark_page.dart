import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/listItem/competition_listitem.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';
import 'package:trajectoria/main.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getBookmarks(),
      child: const _BookmarkPageContent(),
    );
  }
}

class _BookmarkPageContent extends StatefulWidget {
  const _BookmarkPageContent();

  @override
  State<_BookmarkPageContent> createState() => _BookmarkPageContentState();
}

class _BookmarkPageContentState extends State<_BookmarkPageContent>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getBookmarks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.splashBackground,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 80),
            child: Text(
              "Bookmarks",
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, bookmarkState) {
          if (bookmarkState is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (bookmarkState is BookmarksLoaded) {
            if (bookmarkState.bookmarks.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: CompetitionListView(
                  competitions: bookmarkState.bookmarks,
                ),
              );
            } else {
              return const Center(child: Text("Belum ada bookmark"));
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
