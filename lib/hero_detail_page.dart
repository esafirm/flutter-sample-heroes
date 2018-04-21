import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'datastorage.dart' as storage;
import 'superhero.dart';
import 'comments.dart';

class HeroDetailPage extends StatefulWidget {
  HeroDetailPage({this.hero});

  final SuperHero hero;

  @override
  State<StatefulWidget> createState() => new HeroDetailPageState(hero);
}

class HeroDetailPageState extends State<HeroDetailPage>
    with TickerProviderStateMixin {
  HeroDetailPageState(this.hero);

  final TextEditingController inputController = new TextEditingController();
  final SuperHero hero;

  var imageHeight = 250.0;
  var topComments = [];
  var inputComment = "";

  @override
  void initState() {
    super.initState();
    storage.getComments(hero.hashCode).then((comments) => setState(() {
          topComments.addAll(comments);
        }));
  }

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

  void _addComment(BuildContext context) {
    final newComment = inputComment;
    storage.addComment(
        hero.hashCode, new Comment(name: "Botak", comment: newComment));
    inputController.clear();
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text("Comment Added!")));
  }

  Widget buildTopComments() {
    return topComments.isEmpty
        ? new Center(child: new CircularProgressIndicator())
        : new Column(
            children:
                topComments.map((c) => new CommentItem(comment: c)).toList());
  }

  Widget buildAddComment(BuildContext scaffoldContext) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: inputController,
              onChanged: (text) => setState(() {
                    inputComment = text;
                  }),
            ),
          ),
          new MaterialButton(
              onPressed: () => _addComment(scaffoldContext),
              color: Colors.blue,
              child: new Text(
                "Comment",
                style: new TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) => new ListView(
        children: <Widget>[
          new SizedBox(
            height: imageHeight,
            width: double.infinity,
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
          ),
          new Padding(
              padding: new EdgeInsets.all(10.0),
              child:
                  new Text("Comments", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
          buildTopComments(),
          buildAddComment(context)
        ],
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(hero.name)),
      body: buildBody(context),
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;

  CommentItem({this.comment});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10.0),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
              child: new Text(comment.name.substring(0, 1).toUpperCase())),
          new Flexible(
            child: new Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: <Widget>[
              new Text(comment.name),
              new Text(comment.comment)
            ]),
          )
        ],
      ),
    );
  }
}
