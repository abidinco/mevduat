import 'package:mevduat_ceza/shared/themes.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:skeletons/skeletons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'dart:convert';
import '../main.dart';
import 'dart:async';
import 'package:mevduat_ceza/widgets/sliverStickyHeaders.dart' as sliverHeaders;
import 'package:mevduat_ceza/widgets/bottomSheets.dart' as bottomSheets;

class MevzuatFull extends StatefulWidget {
  final String mevzuatId;
  final String mevzuatName;
  final String mevzuatNumber;
  final String updatedAt;
  const MevzuatFull({ Key key, this.mevzuatId, this.mevzuatName, this.updatedAt, this.mevzuatNumber}): super(key: key);
  @override
  _MevzuatFullState createState() => _MevzuatFullState();
}

class _MevzuatFullState extends State<MevzuatFull> {
  TextEditingController _searchQueryController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;
  FocusNode _focusSearch;
  Timer _debounce;
  int _debounceTime = 500;
  @override
  void initState() {
    super.initState();
    _focusSearch = FocusNode();
    _searchQueryController.addListener(_onSearchChanged);
  }
  @override
  void dispose() {
    _focusSearch.dispose();
    _searchQueryController.removeListener(_onSearchChanged);
    _searchQueryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString("assets/json/${widget.mevzuatId}.json"),
          builder: (context, snapshot) {
            var jsonData = json.decode(snapshot.data.toString());
            List<Widget> slivers = [];
            slivers.add(
                new SliverAppBar(
                  pinned: true,
                  expandedHeight: 231.0,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.info_sharp),
                        onPressed: () => showBarModalBottomSheet(
                          context: context,
                          builder: (context) => bottomSheets.bottomSheetInfo(widget.mevzuatName, widget.mevzuatNumber, widget.updatedAt, context),
                        )
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: _isSearching ? _buildSearchField() : Text(widget.mevzuatName),
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset('assets/images/${widget.mevzuatId}.jpg', fit: BoxFit.cover),
                      ],
                    ),
                  ),
                )
            );
            if(snapshot.hasError) {
              return Text("Güçte bir sorun var");
            } else if(snapshot.hasData) {
              if(_searchQuery == null || _searchQuery == "") {
                for(var increment=0;increment<jsonData.length;increment++) {
                  List<Widget> sliversToList = [];
                  for (int j = 0; j < jsonData[increment]['articles'].length; j++) {
                    sliversToList.add(_buildArticleTile(
                        jsonData[increment]['articles'][j]['number'],
                        jsonData[increment]['articles'][j]['title'],
                        jsonData[increment]['articles'][j]['article'],
                        context,
                        null,
                        _focusSearch
                      )
                    );
                  }
                  slivers.add(sliverHeaders.buildSliverStickyHeader(jsonData[increment]['section'], sliversToList, context));
                }
              } else if(RegExp('^[0-9]{1,4}').hasMatch(_searchQuery)) {
                // If user searchs by numbers
                for(var increment=0;increment<jsonData.length;increment++) {
                  List<Widget> sliversToList = [];
                  for (int j = 0; j < jsonData[increment]['articles'].length; j++) {
                    if(
                    jsonData[increment]['articles'][j]['number'].startsWith(_searchQuery.toString())
                    ) {
                      sliversToList.add(_buildArticleTile(
                          jsonData[increment]['articles'][j]['number'],
                          jsonData[increment]['articles'][j]['title'],
                          jsonData[increment]['articles'][j]['article'],
                          context,
                          null,
                          _focusSearch
                        )
                      );
                    }
                  }
                  slivers.add(sliverHeaders.buildSliverStickyWithoutHeader(sliversToList));
                }
              }
              else {
                // If user searchsstrings
                outerloop:
                for(var increment=0;increment<jsonData.length;increment++) {
                  List<Widget> sliversToList = [];
                  for (int j = 0; j < jsonData[increment]['articles'].length; j++) {
                    if(!(jsonData[increment].toString().toLowerCase().contains(_searchQuery.toLowerCase()))) {
                      continue outerloop;
                    } else  if(
                    jsonData[increment]['articles'][j]['number'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        jsonData[increment]['articles'][j]['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        jsonData[increment]['articles'][j]['article'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
                    ) {
                      sliversToList.add(_buildArticleTile(
                          jsonData[increment]['articles'][j]['number'],
                          jsonData[increment]['articles'][j]['title'],
                          jsonData[increment]['articles'][j]['article'],
                          context,
                          _searchQueryController.text,
                          _focusSearch
                      )
                      );
                    }
                  }
                  slivers.add(sliverHeaders.buildSliverStickyHeader(jsonData[increment]['section'], sliversToList, context));
                }
              }
            } else {
              slivers.add(SliverFillRemaining(child: SkeletonListView()));
              return CustomScrollView(
                slivers: slivers,
              );
            }
            return CustomScrollView(
              slivers: slivers,
              physics: BouncingScrollPhysics(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: _fabIcon(_isSearching, context),
        onPressed: () => _fabIconPressed(),
        backgroundColor: appModel.darkTheme ? Colors.white : colorPalette['lightPrimary'],
        elevation: 1.0,
      ),
    );
  }

  _fabIconPressed() {
    if(_isSearching && MediaQuery.of(context).viewInsets.bottom != 0) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } else if(_isSearching && MediaQuery.of(context).viewInsets.bottom == 0) {
      var clear = _searchQueryController.clear;
      clear();
      setState(() {
        _isSearching = false; _searchQuery = "";
      });
    } else {
      setState(() => _isSearching = true);
      _focusSearch.requestFocus();
    }
  }

  Widget _buildSearchField() {
    return Container(
      height: 16.0,
      child: TextField(
        controller: _searchQueryController,
        focusNode: _focusSearch,
        decoration: InputDecoration(
          hintText: "Ara...",
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  _onSearchChanged() {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debounceTime), () {
      if(_searchQueryController.text != "") {
        setState(() => _searchQuery = _searchQueryController.text);
      }
    });
  }
}

Widget _fabIcon(bool _isSearching, BuildContext context) {
  final appModel = Provider.of<AppModel>(context);
  if (_isSearching && MediaQuery.of(context).viewInsets.bottom != 0) {
    return Icon(Icons.keyboard_arrow_down_outlined, color: appModel.darkTheme ? colorPalette['darkPrimary'] : Colors.white);
  } else if (_isSearching && MediaQuery.of(context).viewInsets.bottom == 0) {
    return Icon(Icons.close, color: appModel.darkTheme ? colorPalette['darkPrimary'] : Colors.white);
  } else {
    return Icon(Icons.search, color: appModel.darkTheme ? colorPalette['darkPrimary'] : Colors.white);
  }
}

Widget _buildArticleTile(String number, String title, String article, BuildContext context, String searchQuery, FocusNode focusSearch) {
  final appModel = Provider.of<AppModel>(context);
  var highlightedTitle;
  var highlightedArticle;
  if(searchQuery != null) {
    highlightedTitle = SubstringHighlight(
      text: title,
      term: searchQuery,
      textStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 15.0,
        color: appModel.darkTheme ? Colors.white70 : colorPalette['darkest'],
      ),
    );
    highlightedArticle = SubstringHighlight(
      text: article,
      term: searchQuery,
      textStyle: TextStyle(
        fontSize: 12.0,
        color: appModel.darkTheme ? Colors.white70 : colorPalette['dark'],
      ),
    );
  } else {
    highlightedTitle = Text(
      title.trim(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: 15.0,
      ),
    );
    highlightedArticle = Text(
      article.trim(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12.0,
      ),
      maxLines: 2,
      textAlign: TextAlign.justify,
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: ListTile(
      leading: Container(
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
      title: highlightedTitle,
      subtitle: highlightedArticle,
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          bounce: true,
          expand: false,
          builder: (context) => bottomSheets.bottomSheetArticle(
              number,
              title,
              article,
              context,
              searchQuery
          ),
        );
        focusSearch.unfocus();
      },
    ),
  );
}