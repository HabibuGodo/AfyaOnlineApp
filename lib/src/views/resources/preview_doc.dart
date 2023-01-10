import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';

class PDFViewerCachedFromUrl extends StatefulWidget {
  final String url;
  final String name;
  const PDFViewerCachedFromUrl(
      {Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  State<PDFViewerCachedFromUrl> createState() => _PDFViewerCachedFromUrlState();
}

class _PDFViewerCachedFromUrlState extends State<PDFViewerCachedFromUrl> {
  String urlPDFPath = "";

  bool exists = true;

  int _totalPages = 0;

  int _currentPage = 0;

  bool pdfReady = false;

  bool loaded = false;
  late PDFViewController _pdfViewController;

  @override
  void initState() {
    disableCapture();
    super.initState();
  }

  @override
  void dispose() {
    disableCapture();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          widget.name,
        ),
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: false,
        nightMode: false,
        autoSpacing: true,
        pageFling: true,

        pageSnap: true,
        // fitEachPage: true,
        defaultPage: 0,
        // fitPolicy: FitPolicy.WIDTH,
        preventLinkNavigation: false,
        onError: (e) async {
          EasyLoading.showError(
              "Something went wrong, try again later., try again later");
          // print(e);
          await Future.delayed(const Duration(seconds: 4), () {
            Navigator.of(context).pop();
          });
        },
        onRender: (_pages) {
          setState(() {
            _totalPages = _pages!;
            pdfReady = true;
          });
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            _pdfViewController = vc;
          });
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = page!;
          });
        },
        onPageError: (page, e) {},
      ).cachedFromUrl(
        widget.url,
        maxAgeCacheObject: Duration(days: 7),
        maxNrOfCacheObjects: 100,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text("File not found")),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 30,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (_currentPage > 0) {
                  _currentPage--;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
          Text(
            "${_currentPage + 1}/$_totalPages",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 30,
            // color: goldyColor,
            onPressed: () {
              setState(() {
                if (_currentPage < _totalPages - 1) {
                  _currentPage++;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
