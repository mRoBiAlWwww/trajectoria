import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;
  final Color backgroundColor;
  final bool centerTitle;
  final bool showLeading;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;
  final EdgeInsetsGeometry? actionsPadding;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.onLeadingPressed,
    this.backgroundColor = Colors.transparent,
    this.centerTitle = false,
    this.showLeading = false,
    this.automaticallyImplyLeading = false,
    this.titleSpacing,
    this.toolbarHeight,
    this.bottom,
    this.leadingWidth,
    this.actionsPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      leadingWidth: leadingWidth,
      actionsPadding: actionsPadding,
      leading: showLeading
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize {
    // Tinggi Toolbar (default kToolbarHeight jika null) + Tinggi Bottom (jika ada)
    final double activeToolbarHeight = toolbarHeight ?? kToolbarHeight;
    final double bottomHeight = bottom?.preferredSize.height ?? 0.0;

    return Size.fromHeight(activeToolbarHeight + bottomHeight);
  }
}
