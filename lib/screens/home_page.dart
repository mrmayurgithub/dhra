import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:dhravyatech/constants.dart';
import 'package:dhravyatech/models/product_details.dart';
import 'package:dhravyatech/screens/widgets/details_row.dart';
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
//<----------------------------------Variables & Controllers------------------------------------>
  int _currentPage = 0;
  PanelController _panelController = PanelController();
  final CarouselController carouselController = CarouselController();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isChewieInitialized = false;
  String footerText = "Swipe up for more details";
  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();

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
  }
//<---------------------------------------------------------------------------------------------->

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset('assets/sam3.mp4');
    initVideoPlayer().whenComplete(() => setState(() {
          isChewieInitialized = true;
        }));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

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
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu_outlined),
          ),
          title: Text(
            "Dhravya",
            style: TextStyle(color: Colors.white, fontSize: kDefaultPadding),
          ),
        ),
        body: !isChewieInitialized
            ? Center(child: CircularProgressIndicator())
            : SlidingUpPanel(
                controller: _panelController,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding),
                  topRight: Radius.circular(kDefaultPadding),
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
                            footerText,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //550
                maxHeight: MediaQuery.of(context).size.height - 200 - 100,
                // maxHeight: MediaQuery.of(context).size.height,
                panelBuilder: (sc) => _panel(context, sc),
                onPanelSlide: (position) {
                  _videoPlayerController.pause();
                  setState(() {
                    footerText = "Buy";
                  });
                },
                onPanelClosed: () {
                  _videoPlayerController.play();
                  setState(() {
                    footerText = "Swipe up for more details";
                  });
                },
                body: _body(context),
              ),
      ),
    );
  }

//<----------------------------------Main Body------------------------------------>

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      child: _videoPlayerController.value.isInitialized
          ? Column(
              children: [
                SizedBox(height: kDefaultPadding / 2),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
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

//<----------------------------------SlidingUp Panel------------------------------------>

  MediaQuery _panel(BuildContext context, ScrollController sc) {
    int setCount = -1;

    changeCurrentPage(int index) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          logger.e("Current Page Changing to $index");
          setCount = index;
          _currentPage = index;
        });
      });
    }

    return MediaQuery.removePadding(
      context: context,
      child: ValueListenableBuilder(
        valueListenable: _chewieController.videoPlayerController,
        builder: (context, VideoPlayerValue value, child) {
          int seconds = value.position.inSeconds;
          if (this.mounted) {
            if (seconds >= 0 &&
                seconds < 75 &&
                _currentPage != 0 &&
                setCount != 0)
              changeCurrentPage(0);
            else if (seconds >= 75 &&
                seconds < 139 &&
                _currentPage != 1 &&
                setCount != 1)
              changeCurrentPage(1);
            else if (_currentPage != 2 && seconds >= 139 && setCount != 2)
              changeCurrentPage(2);
          }
          return ListView(
            controller: sc,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    "${productWidgets[_currentPage].modelName}",
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
                      margin: EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2,
                          horizontal: kDefaultPadding / 10),
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
              SizedBox(height: kDefaultPadding),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SelectableText(
                  "Details",
                  style: TextStyle(
                    fontSize: kDefaultPadding,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              DetailsRow(currentPage: _currentPage),
              SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}
