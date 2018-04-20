import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'superhero.dart';

class HeroDetailPage extends StatefulWidget {
  HeroDetailPage({this.hero});

  final SuperHero hero;

  @override
  State<StatefulWidget> createState() => new HeroDetailPageState(hero);
}

class HeroDetailPageState extends State<HeroDetailPage>
    with TickerProviderStateMixin {
  HeroDetailPageState(this.hero);

  final SuperHero hero;

  var imageHeight = 250.0;

  void _handleTap() {
    final AnimationController controller = new AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);

    final end = imageHeight > 250.0 ? 250.0 : 500.0;
    final Animation<double> heightAnimation =
        new Tween<double>(begin: imageHeight, end: end).animate(controller);

    heightAnimation.addListener(() {
      setState(() {
        imageHeight = heightAnimation.value;
        print('change image height to: $imageHeight');
      });
    });

    controller.forward();
  }

  Widget buildBody() => new Container(
        child: new ListView(
          children: <Widget>[
            new SizedBox(
              height: imageHeight,
              width: double.INFINITY,
              child: new Hero(
                tag: hero.hashCode,
                child: new GestureDetector(
                  onTap: _handleTap,
                  child: new CachedNetworkImage(
                      imageUrl: hero.image, fit: BoxFit.cover),
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(hero.desc),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(hero.name)),
      body: buildBody(),
    );
  }
}
