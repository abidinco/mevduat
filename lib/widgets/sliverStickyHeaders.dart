import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mevduat_ceza/shared/themes.dart';
import 'package:provider/provider.dart';
import '../main.dart';

Widget buildSliverStickyHeader(String section, List sliversToList, BuildContext context) {
  final appModel = Provider.of<AppModel>(context);
  return SliverStickyHeader(
    header: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appModel.darkTheme ? colorPalette['lightPrimary'] : colorPalette['darkPrimary'],
        ),
        child: Text(
          section,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        )
    ),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Column(children: sliversToList);
          },
          childCount: 1
      ),
    ),
  );
}

Widget buildSliverStickyWithoutHeader(List sliversToList) {
  return SliverStickyHeader(
    header: Container(
      height: 0,
    ),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Column(
                children: sliversToList
            );
          },
          childCount: 1
      ),
    ),
  );
}