import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatefulWidget {
  final String note;
  final String? createdDate;
  final Function(Map<String, dynamic>) onSave; // Updated to accept Map
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;

  NoteDetailScreen({
    required this.note,
    required this.onSave,
    this.createdDate,
    this.textColor = CupertinoColors.black,
    this.fontSize = 18.0,
    this.textAlign = TextAlign.left,
  });

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _controller;
  late Color _textColor;
  late double _fontSize;
  late TextAlign _textAlign;
  File? _insertedImage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note);
    _textColor = widget.textColor;
    _fontSize = widget.fontSize;
    _textAlign = widget.textAlign;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _insertedImage = File(image.path);
      });
    }
  }

  void _showTextFormattingOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Text Formatting"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.add, size: 28),
                onPressed: () {
                  setState(() {
                    _fontSize += 2;
                  });
                },
              ),
              Container(height: 30, child: VerticalDivider()),
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.minus, size: 28),
                onPressed: () {
                  setState(() {
                    if (_fontSize > 10) _fontSize -= 2;
                  });
                },
              ),
              Container(height: 30, child: VerticalDivider()),
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.paintbrush, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                  _showColorPicker();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.text_alignleft, size: 28),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.left;
                  });
                },
              ),
              Container(height: 30, child: VerticalDivider()),
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.text_aligncenter, size: 28),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.center;
                  });
                },
              ),
              Container(height: 30, child: VerticalDivider()),
              CupertinoActionSheetAction(
                child: Icon(CupertinoIcons.text_alignright, size: 28),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.right;
                  });
                },
              ),
            ],
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Select Text Color",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textColor = CupertinoColors.black;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(backgroundColor: CupertinoColors.black, radius: 20),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textColor = CupertinoColors.systemRed;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(backgroundColor: CupertinoColors.systemRed, radius: 20),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textColor = CupertinoColors.systemBlue;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(backgroundColor: CupertinoColors.systemBlue, radius: 20),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textColor = CupertinoColors.activeGreen;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(backgroundColor: CupertinoColors.activeGreen, radius: 20),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textColor = CupertinoColors.systemOrange;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(backgroundColor: CupertinoColors.systemOrange, radius: 20),
                ),
              ],
            ),
            SizedBox(height: 16),
            CupertinoButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.note.isEmpty ? 'New Note' : 'Edit Note',
          style: TextStyle(fontSize: 16),
        ),
        trailing: GestureDetector(
          onTap: () {
            widget.onSave({
              "content": _controller.text.trim(),
              "textColor": _textColor.value,
              "fontSize": _fontSize,
              "textAlign": _textAlign.index,
            });
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(fontSize: 16, color: CupertinoColors.activeBlue)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (widget.createdDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created: ${DateFormat.yMd().add_jm().format(DateTime.parse(widget.createdDate!))}',
                      style: TextStyle(fontSize: 14, color: CupertinoColors.inactiveGray),
                    ),
                    Divider(height: 16, thickness: 0.5, color: CupertinoColors.separator),
                  ],
                ),
              ),
            if (_insertedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_insertedImage!)),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoTextField(
                  controller: _controller,
                  maxLines: 10,
                  style: TextStyle(fontSize: _fontSize, color: _textColor),
                  textAlign: _textAlign,
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: 'Write your note here...',
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(border: Border.all(color: CupertinoColors.inactiveGray)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                border: Border(top: BorderSide(color: CupertinoColors.separator)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.photo, size: 28),
                    onPressed: _pickImage,
                  ),
                  Container(height: 30, child: VerticalDivider()),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.textformat, size: 28),
                    onPressed: _showTextFormattingOptions,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}