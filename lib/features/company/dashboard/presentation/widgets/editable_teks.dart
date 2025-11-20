import 'package:flutter/material.dart';

class EditableTextItem extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool>? onEditingChanged;
  final bool needWrapText;

  const EditableTextItem({
    super.key,
    required this.text,
    required this.onChanged,
    this.onEditingChanged,
    this.needWrapText = false,
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black, width: 1),
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
          : Text(
              widget.text,
              key: ValueKey("text-${widget.text}"),
              overflow: widget.needWrapText ? TextOverflow.ellipsis : null,
              maxLines: widget.needWrapText ? 2 : null,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
