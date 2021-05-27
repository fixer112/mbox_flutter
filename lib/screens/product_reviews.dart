import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/dummy_data/reviews.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'dart:async';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';


class ProductReviews extends StatefulWidget {

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  final TextEditingController _myReviewTextController = TextEditingController();
  final ScrollController _reviewScrollController = ScrollController();

  double _my_rating = existing_rating;
  String _my_review = existing_review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildProductReviewsList(),
                    ),
                    Container(
                      height: 120,
                    )
                  ]),
                )
              ],
            ),
            //original
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white54.withOpacity(0.6)),
                    height: 120,
                    //color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                      child: buildGiveReviewSection(context),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Reviews",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  SingleChildScrollView buildProductReviewsList() {
    return SingleChildScrollView(
      child: ListView.builder(
        controller: _reviewScrollController,
        itemCount: reviewList.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: buildProductReviewsItem(index),
          );
        },
      ),
    );
  }

  buildProductReviewsItem(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom:8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                //shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset( reviewList[index].image)),
            ),
            Column(
              children: [
                Container(
                  width: 180,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          reviewList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              height: 1.6,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom:4.0),
                          child: Text(reviewList[index].date,style: TextStyle(color: MyTheme.medium_grey),),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(top:0.0,bottom: 0.0,left: 16.0),
              child: Container(
                child: RatingBar(
                  itemSize: 12.0,
                  ignoreGestures: true,
                  initialRating: reviewList[index].rating,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(FontAwesome.star, color: Colors.amber),
                    empty:
                    Icon(FontAwesome.star, color: Color.fromRGBO(224, 224, 225, 1)),
                  ),
                  itemPadding: EdgeInsets.only(right: 1.0),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              )
            )
          ]),

          Padding(
            padding: const EdgeInsets.only(left:56.0),
            child: buildExpandableDescription(index),
          )
        ],
      ),
    );
  }

  ExpandableNotifier buildExpandableDescription(index) {

    return ExpandableNotifier(
        child: ScrollOnExpand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expandable(
                collapsed: Container(
                    height:reviewList[index].text.length > 100 ? 32 : 16, child: Text(reviewList[index].text,style: TextStyle(color: MyTheme.font_grey))),
                expanded: Container(child: Text(reviewList[index].text,style: TextStyle(color: MyTheme.font_grey))),
              ),
              reviewList[index].text.length > 100 ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context);
                      return FlatButton(
                        child: Text(
                          !controller.expanded ? "View More" : "Show Less",
                          style: TextStyle(color: MyTheme.font_grey, fontSize: 11),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  ),
                ],
              ) : Container(),
            ],
          ),
        ));
  }


  buildGiveReviewSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: RatingBar.builder(
            itemSize: 20.0,
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            glowColor: Colors.amber,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) {
              return Icon(FontAwesome.star, color: Colors.amber);
            },
            onRatingUpdate: (rating) {
              setState(() {
                _my_rating = rating;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              width: (MediaQuery.of(context).size.width - 32) * (4 / 5),
              child: TextField(
                autofocus: false,
                maxLines: null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                controller: _myReviewTextController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(251, 251, 251, 1),
                    hintText: "Type your review here ...",
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: MyTheme.textfield_grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.medium_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 16.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  var myReviewText = _myReviewTextController.text.toString();
                  //print(chatText);
                  if (myReviewText == "") {
                    ToastComponent.showDialog("Review cannot be empty", context,
                        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                  }
                  if (_my_rating < 1.0) {
                    ToastComponent.showDialog("Atleast one star must be given", context,
                        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                    //shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }




}
