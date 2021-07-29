import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:dhravyatech/models/product_details.dart';
import 'package:dhravyatech/screens/widgets/image_widget.dart';
import 'package:dhravyatech/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  PanelController _panelController = PanelController();
  final CarouselController carouselController = CarouselController();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  // ignore: unused_field
  late Future<void> _future;
  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
          autoInitialize: true,
          fullScreenByDefault: false,
          allowFullScreen: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(errorMessage),
            );
          });
    });
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset('assets/sam3.mp4');
    _future = initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  List productWidgets = [
    ProductDetails(
      url: 'assets/a32.png',
      modelName: "Samsung Galaxy A32",
      brand: "Samsung",
      storage: 128,
      ram: 6,
      os: "Android 11.0",
      color: "White",
      screenSize: 6.7,
      displayType: "SAMOLED",
    ),
    ProductDetails(
      url: 'assets/m31.png',
      modelName: "Samsung Galaxy M31",
      brand: "Samsung",
      storage: 64,
      ram: 4,
      os: "Android",
      color: "Blue",
      screenSize: 6.4,
      displayType: "AMOLED",
    ),
    ProductDetails(
      url: 'assets/m51_2.png',
      modelName: "Samsung Galaxy M51",
      brand: "Samsung",
      storage: 128,
      ram: 6,
      os: "Android",
      color: "Black",
      screenSize: 6.7,
      displayType: "SAMOLED Plus",
    ),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Dhravya",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        padding: EdgeInsets.only(top: 0),
        minHeight: 70,
        maxHeight: 520,
        // parallaxEnabled: true,
        // parallaxOffset: 0.5,
        panelBuilder: (sc) => _panel(context, sc),
        onPanelSlide: (position) {
          _videoPlayerController.pause();
        },
        onPanelClosed: () {
          _videoPlayerController.play();
          logger.e("TIME : ${_videoPlayerController.value.duration.inSeconds}");
        },
        body: _body(context),
      ),
    );
  }

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          _videoPlayerController.value.isInitialized
              ? Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  MediaQuery _panel(BuildContext context, ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          controller: sc,
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: () {
                if (_panelController.isPanelOpen) {
                  _panelController.close();
                } else
                  _panelController.open();
              },
              child: Center(
                child: Text(
                  "More",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CarouselSlider(
                carouselController: carouselController,
                items: [
                  for (ProductDetails e in productWidgets)
                    ImageWidget(productDetails: e),
                ],
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                      if (_currentPage == 0)
                        _videoPlayerController.seekTo(Duration(seconds: 0));
                      else if (_currentPage == 1)
                        _videoPlayerController.seekTo(Duration(seconds: 75));
                      else if (_currentPage == 2)
                        _videoPlayerController.seekTo(Duration(seconds: 139));
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(productWidgets, (index, url) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Specifications",
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].modelName}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].brand}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].storage}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].ram}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].os}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].color}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].screenSize}",
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Model Name - ${productWidgets[_currentPage].displayType}",
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  color: Colors.blue.shade600,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Buy",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
