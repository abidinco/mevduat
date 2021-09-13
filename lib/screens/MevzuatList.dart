import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'MevzuatFull.dart';
import 'dart:convert';

class MevzuatList extends StatefulWidget {
  MevzuatList({Key key}) : super(key: key);
  @override
  _MevzuatListState createState() => _MevzuatListState();
}

class _MevzuatListState extends State<MevzuatList> {
  @override
  Widget build(BuildContext context) {
    List<String> titles = [];
    List<String> ids = [];
    List<Widget> images = [];
    List<String> updatedAts = [];
    List<String> numbers = [];
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString("assets/json/mevzuat.json"),
            builder: (context, snapshot) {
              var jsonData = json.decode(snapshot.data.toString());
              if(snapshot.hasError) {
                return Text("Güçte bir sorun var");
              } else if(snapshot.hasData) {
                for(int i=0;i<jsonData.length;i++) {
                  titles.add(jsonData[i]['name']);
                  ids.add(jsonData[i]['id']);
                  updatedAts.add(jsonData[i]['updatedAt']);
                  numbers.add(jsonData[i]['number']);
                  images.add(ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      "assets/images/${jsonData[i]['id']}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ));
                }
                final appModel = Provider.of<AppModel>(context);
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: VerticalCardPager(
                          textStyle: TextStyle(
                              fontFamily: "Bevan",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(
                                blurRadius: 5.0,
                                color: Colors.black54,
                                offset: Offset(5.0, 5.0),
                              ),Shadow(
                                blurRadius: 5.0,
                                color: Color(0xFF240B36),
                                offset: Offset(-5.0, -5.0),
                              )]
                          ),
                          titles: titles,
                          images: images,
                          initialPage: (jsonData.length/2).floor(),
                          onSelectedItem: (index) {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MevzuatFull(
                                          mevzuatId: ids[index],
                                          mevzuatName: titles[index],
                                          mevzuatNumber: numbers[index],
                                          updatedAt: updatedAts[index],
                                        )
                                )
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 75.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                  child: Text("mevduat hakkında"),
                                  onPressed: () => showBarModalBottomSheet(
                                    context: context,
                                    builder: (context) => _bottomSheetInfo(context),
                                  )
                              ),
                              IconButton(
                                icon: Icon(appModel.darkTheme ? Icons.light_mode : Icons.dark_mode),
                                onPressed: () => appModel.darkTheme = !appModel.darkTheme,
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                );
              } else {
                return Text("Mevduat yükleniyor...");
              }
            },
          )
      ),
    );
  }
}

Widget _bottomSheetInfo(BuildContext context) {
  final appModel = Provider.of<AppModel>(context);
  return SizedBox(
    height: (MediaQuery.of(context).size.height / 3) * 2,
    child: ListView(
      children: <Widget>[
        Image.asset(
          "assets/images/mevduat.jpg",
          fit: BoxFit.cover,
          height: 150.0,
        ),
        ExpansionTile(
          textColor: appModel.darkTheme ? Colors.white70 : Colors.black,
          iconColor: appModel.darkTheme ? Colors.white70 : Colors.black,
          childrenPadding: EdgeInsets.only(top: 5.0, right: 20.0, left: 20.0, bottom: 15.0),
          title: Text("neden mevduat?", style: TextStyle(fontFamily: "Bevan")),
          children: [
            Text(
              "\t\t\t\t\t\t\t\tAnayasa'nın başlangıç metninin son cümlesinde \"... Anayasa'nın demokrasiye aşık Türk evlatlarının vatan ve millet sevgisine emanet ve tevdi olunduğu\" belirtilir.\n\t\t\t\t\t\t\t\tBu ifadeden yola çıkarak \"yasaların yasakoyucu tarafından uygulayıcılara tevdi edildiği\" güzellemesiyle mevduat dendi.",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Poppins",
                color: appModel.darkTheme ? Colors.white70 : Colors.black,
              ),
              textAlign: TextAlign.justify,
            )
          ],
        ),

        ExpansionTile(
          textColor: appModel.darkTheme ? Colors.white70 : Colors.black,
          iconColor: appModel.darkTheme ? Colors.white70 : Colors.black,
          childrenPadding: EdgeInsets.only( top: 5.0, right: 20.0, left: 20.0, bottom: 15.0),
          title: Text("geliştirici", style: TextStyle(fontFamily: "Bevan")),
          children: [
            Text(
              "z. abidin a.\n\ne-mail: z@abidin.co",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appModel.darkTheme ? Colors.white70 : Colors.black,
                fontFamily: "Poppins",
                fontSize: 18.0
              )
            ),
          ],
        )
      ]
    ),
  );
}