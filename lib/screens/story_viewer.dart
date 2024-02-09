import 'package:alaa_admin/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StoryViewer extends StatefulWidget {
  final Story story;

  const StoryViewer({super.key, required this.story});
  @override
  _StoryViewer createState() => _StoryViewer();
}

class _StoryViewer extends State<StoryViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.story.pdf,
        key: _pdfViewerKey,
      ),
    );
  }
}