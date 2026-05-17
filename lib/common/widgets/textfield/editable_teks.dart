import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class EditableTextItem extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool>? onEditingChanged;
  final bool needWrapText;
  final String source;
  final bool isHaveBackground;

  const EditableTextItem({
    super.key,
    required this.text,
    required this.onChanged,
    this.onEditingChanged,
    this.needWrapText = false,
    this.source = "nonprofile",
    this.isHaveBackground = false,
  });

  @override
  State<EditableTextItem> createState() => _EditableTextItemState();
}

class _EditableTextItemState extends State<EditableTextItem> {
  bool isEditing = false;
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);

    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          isEditing = false;
        });
        widget.onEditingChanged?.call(false);
        widget.onChanged(controller.text);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isEditing = true);
        widget.onEditingChanged?.call(true);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: widget.isHaveBackground
              ? LinearGradient(
                  colors: [
                    (AppColors.thirdBackGroundButton),
                    Color(0xFFD2D2D2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: widget.isHaveBackground ? null : Colors.transparent,
        ),

        child: isEditing
            ? SizedBox(
                key: ValueKey("field-${widget.text}"),
                width: 100,
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  focusNode: focusNode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    widget.onChanged(value);
                    setState(() => isEditing = false);
                  },
                  onEditingComplete: () {
                    widget.onChanged(controller.text);
                    setState(() => isEditing = false);
                  },
                ),
              )
            : widget.source == "profile"
            ? Center(child: textWidget())
            : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: textWidget(),
                ),
              ),
      ),
    );
  }

  Widget textWidget() {
    return Text(
      widget.text,
      overflow: widget.needWrapText ? TextOverflow.ellipsis : null,
      maxLines: widget.needWrapText ? 2 : null,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        color: widget.source == "profile"
            ? AppColors.disableTextButton
            : Colors.black,
      ),
    );
  }
}
