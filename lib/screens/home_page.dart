import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:dhravyatech/models/product_details.dart';
import 'package:dhravyatech/screens/widgets/image_widget.dart';
import 'package:dhravyatech/utils/logger.dart';
import 'package:flutter/cupertino.dart';
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
      price: "₹20,499",
      modelName: "Samsung Galaxy A32",
      brand: "Samsung",
      storage: 128,
      ram: 6,
      os: "Android 11.0",
      color: "Black",
      screenSize: 6.7,
      displayType: "SAMOLED",
    ),
    ProductDetails(
      url: 'assets/m31.png',
      price: "₹15,650",
      modelName: "Samsung Galaxy M31",
      brand: "Samsung",
      storage: 64,
      ram: 6,
      os: "Android",
      color: "Blue",
      screenSize: 6.4,
      displayType: "AMOLED",
    ),
    ProductDetails(
      url: 'assets/m51_2.png',
      price: "₹19,999",
      modelName: "Samsung Galaxy M51",
      brand: "Samsung",
      storage: 128,
      ram: 6,
      os: "Android",
      color: "White",
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Dhravya",
            style: TextStyle(color: Colors.white, fontSize: 20),
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
          footer: GestureDetector(
            onTap: () {
              if (_panelController.isPanelOpen) {
                _panelController.close();
              } else
                _panelController.open();
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  color: Colors.blue.shade600,
                  height: 70,
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
          ),
          // maxHeight: 540,
          maxHeight: MediaQuery.of(context).size.height,
          panelBuilder: (sc) => _panel(context, sc),
          onPanelSlide: (position) => _videoPlayerController.pause(),
          onPanelClosed: () => _videoPlayerController.play(),
          body: _body(context),
        ),
      ),
    );
  }

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      child: _videoPlayerController.value.isInitialized
          ? Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        "Best 3 Samsung Smartphones Under 20,000",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  MediaQuery _panel(BuildContext context, ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      child: StatefulBuilder(builder: (context, setState) {
        // int seconds = _videoPlayerController.value.duration.inSeconds;
        // if (seconds <= 0 && seconds < 75)
        //   setState(() {
        //     _currentPage = 0;
        //   });
        // else if (seconds <= 75 && seconds < 139)
        //   setState(() {
        //     _currentPage = 1;
        //   });
        // else
        //   setState(() {
        //     _currentPage = 2;
        //   });
        return ListView(
          controller: sc,
          shrinkWrap: true,
          children: [
            // GestureDetector(
            //   onTap: () {
            //     if (_panelController.isPanelOpen) {
            //       _panelController.close();
            //     } else
            //       _panelController.open();
            //   },
            //   child: Center(
            //     child: Text(
            //       "More",
            //       style: TextStyle(fontSize: 20),
            //     ),
            //   ),
            // ),
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
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SelectableText(
                "${productWidgets[_currentPage].price}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SelectableText(
                "Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailName("Model Name -"),
                    DetailName("Brand -"),
                    DetailName("Storage -"),
                    DetailName("Ram -"),
                    DetailName("OS -"),
                    DetailName("Color -"),
                    DetailName("Screen Size -"),
                    DetailName("Display Type -"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DetailItem("${productWidgets[_currentPage].modelName}"),
                    DetailItem("${productWidgets[_currentPage].brand}"),
                    DetailItem("${productWidgets[_currentPage].storage} GB"),
                    DetailItem("${productWidgets[_currentPage].ram} GB"),
                    DetailItem("${productWidgets[_currentPage].os}"),
                    DetailItem("${productWidgets[_currentPage].color}"),
                    DetailItem(
                        "${productWidgets[_currentPage].screenSize} Inches"),
                    DetailItem("${productWidgets[_currentPage].displayType}"),
                  ],
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 8),
            //     child: Container(
            //       color: Colors.blue.shade600,
            //       height: 60,
            //       width: MediaQuery.of(context).size.width,
            //       child: Center(
            //         child: Text(
            //           "Buy",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w800,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      }),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String text;
  DetailItem(this.text);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SelectableText(
          text,
          style: TextStyle(
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class DetailName extends StatelessWidget {
  final String text;
  DetailName(this.text);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SelectableText(
          text,
          style: TextStyle(
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
