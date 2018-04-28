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

  final EMPTY_COMMENTS = new List<Comment>();

  var imageHeight = 250.0;
  var topComments = [];
  var inputComment = "";
  var isCommentEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  _fetchComments() async {
    final comments = await storage.getComments(hero.id);
    setState(() {
      if (comments.isEmpty) {
        topComments = EMPTY_COMMENTS;
      } else {
        topComments = comments;
      }
    });
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

  void _addComment(BuildContext context) async {
    final newComment = inputComment;
    await storage.addComment(
        hero.id, new Comment(name: "Botak", comment: newComment));
    inputController.clear();
    _fetchComments();
  }

  Widget buildTopComments() {
    return topComments == EMPTY_COMMENTS
        ? new Center(child: new Text("No Comments Yet. Write One!"))
        : topComments.isEmpty
            ? new Center(child: new CircularProgressIndicator())
            : new Column(
                children: topComments
                    .map((c) => new CommentItem(comment: c))
                    .toList());
  }

  Widget buildAddComment(BuildContext scaffoldContext) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              decoration:
                  new InputDecoration(hintText: "Input your comment here..."),
              controller: inputController,
              enabled: true,
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
              child: new Text("Comments",
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold))),
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
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
              child: new Text(comment.name.substring(0, 1).toUpperCase())),
          new Flexible(
            child: new Padding(
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(comment.name,
                        style: new TextStyle(fontWeight: FontWeight.w600)),
                    new Text(comment.comment)
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
