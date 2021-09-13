import 'package:flutter/material.dart';
import 'package:mevduat_ceza/shared/themes.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../main.dart';

Widget bottomSheetInfo(String mevzuatName, String mevzuatNumber, String updatedAt, BuildContext context) {
  final appModel = Provider.of<AppModel>(context);
  return SizedBox(
    height: (MediaQuery.of(context).size.height / 4),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 40.0),
      child: Text(
        "\t\t\t\t\t\t\t\t$mevzuatNumber sayılı $mevzuatName $updatedAt'de güncellendi.\n\t\t\t\t\t\t\t\tHata olduğunu düşünüyorsanız iletişime geçin. e-mail: z@abidin.co",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 18.0,
          color: appModel.darkTheme ? Colors.white70 : Colors.black,
        ),
      ),
    ),
  );
}

Widget bottomSheetArticle(String number, String title, String article, BuildContext context, String searchQuery) {
  var titleReversed = List.from(title.split(" < ").reversed).join(" >  ");
  var highlightedArticle;
  final appModel = Provider.of<AppModel>(context);
  if(searchQuery != null) {
    highlightedArticle = SubstringHighlight(
      text: article,
      term: searchQuery,
      textAlign: TextAlign.justify,
      textStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 16.0,
        color: appModel.darkTheme ? Colors.white70 : colorPalette['darkest'],
      ),
    );
  } else {
    highlightedArticle = Text(
        article,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16.0,
          color: appModel.darkTheme ? colorPalette['lighter'] : Colors.black,
        )
    );
  }
  return SizedBox(
    height: (MediaQuery.of(context).size.height / 3) * 2,
    child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: appModel.darkTheme ? colorPalette['lightPrimary'] : colorPalette['darkPrimary'],
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: appModel.darkTheme ? colorPalette['lightPrimary'] : colorPalette['darkPrimary'],
                      width: 1,
                    )
                ),
                child: Center(
                  child: Text(
                      number,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20.0,
                        color: Colors.white,
                      )
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                  child: Text(
                    titleReversed,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20.0,
                      color: appModel.darkTheme ? Colors.white70 : colorPalette['darkPrimary'],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: highlightedArticle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SizedBox(
            height: 60.0,
            child: Placeholder(),
          ),
        )
      ],
    ),
  );
}