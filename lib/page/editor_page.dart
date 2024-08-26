import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;
import 'package:get/get.dart';
import 'package:znote/controller/editor_page_controller.dart';
import 'package:znote/controller/write_controller.dart';

class EditorPage extends StatelessWidget {
  final EditorPageController _editorPageController = Get.put(EditorPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: _controller,
              configurations: const Quill.QuillSimpleToolbarConfigurations(),
            ),
            Expanded(
              child: Quill.QuillEditor.basic(
                controller: _editorPageController.quillController,
                // configurations: const Quill.QuillEditorConfigurations(),
                readOnly: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
