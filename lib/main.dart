import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api_requester.dart' as api;
import 'hollow_text.dart';
import 'hero_detail_page.dart';
import 'superhero.dart';

final EMPTY_IMAGE =
    "https://vignette.wikia.nocookie.net/yakusokunoneverland/images/3/3c/NoImageAvailable.png/revision/latest/scale-to-width-down/480?cb=20160910192028";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HeroesPage(title: 'Heroes'),
    );
  }
}

class HeroesPage extends StatefulWidget {
  HeroesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HeroesPageState createState() => new _HeroesPageState();
}

class _HeroesPageState extends State<HeroesPage> {
  final List<Widget> _gridItems = <Widget>[];

  @override
  void initState() {
    super.initState();

    api
        .fetchHeroes()
        .then((result) => (result['results']))
        .then((result) => (setState(() {
              result.forEach((i) {
                _gridItems
                    .add(new GridItem.withHero(new SuperHero.fromJson(i)));
              });
              print("Fetch complete!");
            })));
  }

  Widget buildGrid() => _gridItems.isEmpty
      ? new Center(child: new CircularProgressIndicator())
      : new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          children: this._gridItems,
        );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: buildGrid());
  }
}

class GridItem extends StatelessWidget {
  final SuperHero hero;

  GridItem.withHero(this.hero);

  Widget buildImage(String imageUrl) => new Hero(
        tag: hero.hashCode,
        child: new Container(
          constraints: new BoxConstraints.expand(),
          child: new CachedNetworkImage(
              imageUrl: imageUrl == null ? EMPTY_IMAGE : imageUrl,
              fit: BoxFit.cover),
        ),
      );

  Widget buildText(String name) => new Container(
      constraints: new BoxConstraints.expand(),
      child: new Center(
          child: new CustomPaint(
              painter: new HollowText(Colors.black.withAlpha(170),
                  name.substring(0, 1).toUpperCase()))));

  void _handleTap(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new HeroDetailPage(hero: hero)));
  }

  @override
  Widget build(BuildContext context) => new Material(
        child: new Card(
            child: new Stack(
          children: <Widget>[
            buildImage(hero.image),
            buildText(hero.name),
            new Material(
              color: Colors.transparent,
              child: new InkWell(onTap: () => _handleTap(context)),
            )
          ],
        )),
      );
}
