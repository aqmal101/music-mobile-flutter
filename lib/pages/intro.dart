import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'dart:developer' as developer;

import 'package:music_app/pages/welcome.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];
  final Color primaryColor = const Color.fromARGB(255, 255, 174, 0);

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      ContentConfig(
        title: "Welcome!",
        textAlignTitle: TextAlign.left,
        textAlignDescription: TextAlign.left,
        maxLineTitle: 2,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
          height: 0.9, // Decrease line height for title
        ),
        description: "What kind of music you listen to?",
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Raleway',
          height: 1.0, // Adjust line height for description if needed
        ),
        backgroundNetworkImage:
            "https://raw.githubusercontent.com/aqmal101/background-image/refs/heads/main/woman-listen-music.jpg",
        backgroundFilterOpacity: 0.5,
        backgroundFilterColor: Colors.black38,
        onCenterItemPress: () {},
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: "Pop Music",
        maxLineTitle: 2,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Enjoy the upbeat rhythms and catchy melodies of the latest pop hits that are sure to lift your spirits.",
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        backgroundNetworkImage:
            "https://raw.githubusercontent.com/aqmal101/background-image/refs/heads/main/billie-elish.jpeg",
        backgroundFilterOpacity: 0.5,
        backgroundFilterColor: Colors.black38,
        onCenterItemPress: () {},
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: "Classical & Instrumental Music",
        maxLineTitle: 2,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Experience tranquility and beauty through classical and instrumental melodies that transport you to a peaceful state of mind.",
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        backgroundNetworkImage:
            "https://raw.githubusercontent.com/aqmal101/background-image/refs/heads/main/classical.jpeg",
        backgroundFilterOpacity: 0.5,
        backgroundFilterColor: Colors.black38,
        onCenterItemPress: () {},
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: "Anime, Game, and Lofi Music",
        maxLineTitle: 2,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Enter a fantasy world with anime music, enjoy soundtracks from your favorite games, and find serenity in the calming beats of lofi.",
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        backgroundNetworkImage:
            "https://raw.githubusercontent.com/aqmal101/background-image/refs/heads/main/anime.jpeg",
        backgroundFilterOpacity: 0.5,
        backgroundFilterColor: Colors.black38,
        onCenterItemPress: () {},
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  void onTabChangeCompleted(index) {
    developer.log("onTabChangeCompleted, index: $index");
  }

  Widget renderPrevBtn() {
    return Icon(
      Icons.navigate_before,
      color: primaryColor,
      size: 35.0,
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: primaryColor,
      size: 35.0,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: primaryColor,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: primaryColor,
      size: 35.0,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromARGB(51, 111, 63, 0),
      ),
      overlayColor: WidgetStateProperty.all<Color>(
        const Color(0x33ffcc5c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      },
      // Indicator
      indicatorConfig: const IndicatorConfig(
        colorIndicator: Color(0xffffcc5c),
        sizeIndicator: 6.0,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),
      onTabChangeCompleted: onTabChangeCompleted,
      renderPrevBtn: renderPrevBtn(),
      renderNextBtn: renderNextBtn(),
      renderDoneBtn: renderDoneBtn(),
      renderSkipBtn: renderSkipBtn(),
      prevButtonStyle: myButtonStyle(),
      nextButtonStyle: myButtonStyle(),
      doneButtonStyle: myButtonStyle(),
      skipButtonStyle: myButtonStyle(),
    );
  }
}
