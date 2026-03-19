import 'package:flutter/material.dart';

class NoteInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String label;
  final String hintText;
  final String emoji;
  final int maxLines;
  final int maxLength;

  const NoteInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.label = '📝 Nội dung chuyển khoản',
    this.hintText = 'VD: Chuyen tien mua banh mi',
    this.emoji = '📝',
    this.maxLines = 1,
    this.maxLength = 100,
  });

  @override
  State<NoteInputWidget> createState() => _NoteInputWidgetState();
}

class _NoteInputWidgetState extends State<NoteInputWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),

        // Input Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused
                  ? Color(0xFF667eea).withOpacity(0.6)
                  : Colors.white.withOpacity(0.1),
              width: 2,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: Color(0xFF667eea).withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              counterText: '',
              counterStyle: TextStyle(fontSize: 0),
            ),
            onChanged: widget.onChanged,
          ),
        ),

        // Character Counter
        SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            '${widget.controller.text.length}/${widget.maxLength}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
