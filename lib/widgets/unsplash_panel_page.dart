/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/focus_keyboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashPanelPage extends StatelessWidget {
  static const String routeName = "unsplash_panel";

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Text("Unsplash", style: Theme.of(context).textTheme.headline6),
            Divider(),
            Material(
              type: MaterialType.transparency,
              child: TabBar(
                tabs: [
                  Tab(child: Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text("Random")])),
                  Tab(child: Row(children: [Icon(Icons.search), SizedBox(width: 8), Text("Search")])),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(child: TabBarView(children: [_RandomTab(), _SearchTab()])),
          ],
        ),
      );
}

class _RandomTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 16 / 9,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _randomCard("Abstract"),
            _randomCard("Minimal"),
            _randomCard("Texture"),
            _randomCard("Nature"),
            _randomCard("Architecture"),
            _randomCard("Plant"),
            _randomCard("Technology"),
            _randomCard("Wallpaper"),
            _randomCard("Colorful"),
            _randomCard("Space"),
          ]);

  Widget _randomCard(String text) => Focus(
        canRequestFocus: false,
        child: Builder(
          builder: (context) => Card(
            clipBehavior: Clip.antiAlias,
            shape: _cardBorder(Focus.of(context).hasFocus),
            child: InkWell(
              onTap: () => context.read<WallpaperService>().random(text),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Ink.image(image: AssetImage("assets/abstract.png"), width: 32),
                    SizedBox(width: 8),
                    Flexible(child: Text(text, overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  ShapeBorder? _cardBorder(bool hasFocus) => hasFocus
      ? RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(4))
      : null;
}

class _SearchTab extends StatefulWidget {
  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  List<Photo> _searchResults = [];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 16),
            child: FocusKeyboardListener(
              onPressed: (key) {
                if (key == LogicalKeyboardKey.arrowDown) {
                  FocusScope.of(context).nextFocus();
                  return KeyEventResult.handled;
                }
                if (key == LogicalKeyboardKey.arrowUp) {
                  FocusScope.of(context).previousFocus();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              builder: (context) => TextFormField(
                decoration: InputDecoration(labelText: "Search", isDense: true),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onFieldSubmitted: (value) async {
                  _searchResults = [];
                  setState(() {});
                  _searchResults = await context.read<WallpaperService>().search(value);
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 16 / 11,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _searchResults.asMap().entries.map((item) => _searchResultCard(item.key, item.value)).toList(),
            ),
          ),
        ],
      );

  Widget _searchResultCard(int index, Photo photo) => Focus(
        canRequestFocus: false,
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: _cardBorder(Focus.of(context).hasFocus),
                  child: InkWell(
                    autofocus: index == 0,
                    focusColor: Colors.transparent,
                    onTap: () => context.read<WallpaperService>().setFromUnsplash(photo),
                    child: Ink.image(image: NetworkImage(photo.urls.small.toString()), fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  photo.user.name,
                  style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.underline),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );

  ShapeBorder? _cardBorder(bool hasFocus) => hasFocus
      ? RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(4))
      : null;
}
