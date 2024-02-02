import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/modules/books/controllers/books_controller.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/images/web_image.dart';
import 'package:forgottenland/views/widgets/src/other/better_text.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class BookWidget extends StatefulWidget {
  const BookWidget(this.book);

  final Book book;

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  bool expandedView = false;

  BooksController booksCtrl = Get.find<BooksController>();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
        decoration: _decoration(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _sprites(),
                      const SizedBox(width: 5),
                      Expanded(child: _name()),
                      const SizedBox(width: 5),
                      _toggleViewButton(),
                    ],
                  ),
                  if (expandedView && _authorText != null) _divider(),
                  if (expandedView && _authorText != null) _author(),
                  if (expandedView || _descriptionText != null) _divider(),
                  if (!expandedView && _descriptionText != null) _description(),
                  if (expandedView) _text(),
                  if (expandedView) _divider(),
                  if (expandedView) _locations(),
                ],
              ),
            ),
          ],
        ),
      );

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.bgPaper),
      );

  Widget _sprites() => Container(
        height: 32,
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.book.sprites.length,
          itemBuilder: (_, int i) => _spriteItemBuilder(
            'https://raw.githubusercontent.com/s2ward/tibia/main/img/book/${widget.book.sprites[i]}.png',
          ),
        ),
      );

  Widget _spriteItemBuilder(String src) {
    final Image image = Image.network(src);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(ImageConfiguration.empty).addListener(
          ImageStreamListener(
            (ImageInfo info, _) => completer.complete(info.image),
          ),
        );

    return FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(right: 5),
            child: WebImage(
              src,
              fit: BoxFit.none,
              width: snapshot.data?.width.toDouble(),
              backgroundColor: AppColors.bgPaper,
              borderColor: AppColors.bgPaper,
            ),
          );
        }
        return Container(width: 32);
      },
    );
  }

  Widget _name() {
    if (expandedView) {
      return SelectableText(
        widget.book.name ?? '',
        style: const TextStyle(
          fontSize: 13,
          height: 16 / 13,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.left,
      );
    }

    return Text(
      widget.book.name ?? '',
      style: const TextStyle(
        fontSize: 13,
        height: 32 / 13,
        color: AppColors.primary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _author() => BetterText(
        _authorText ?? '',
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.left,
      );

  String? get _authorText {
    if (widget.book.author == null) return null;
    if (widget.book.author == '?') return null;
    return 'Author: ${widget.book.author}';
  }

  Widget _description() => BetterText(
        _descriptionText ?? '',
        selectable: false,
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          color: AppColors.textSecondary,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.left,
        maxLines: 3,
      );

  String? get _descriptionText {
    if (widget.book.description == '?') return null;
    return _resultDescriptionText;
  }

  String get _resultDescriptionText {
    final String filter = booksCtrl.searchController.text;
    String result = widget.book.description ?? '';
    if (filter.isEmpty) return result;
    if (widget.book.text == null) return result;
    result = result.replaceAll(filter, '<primary>$filter<primary>');
    result = result.replaceAll(filter.toLowerCase(), '<primary>${filter.toLowerCase()}<primary>');
    result = result.replaceAll(filter.toUpperCase(), '<primary>${filter.toUpperCase()}<primary>');
    result = result.replaceAll(
      filter.substring(0, 1).toUpperCase() + filter.substring(1).toLowerCase(),
      '<primary>${filter.substring(0, 1).toUpperCase() + filter.substring(1).toLowerCase()}<primary>',
    );
    result = result.replaceAll('<primary><primary>', '<primary>');
    return result;
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
        child: const Divider(height: 1, color: AppColors.bgDefault),
      );

  Widget _text() => BetterText(
        _resultText,
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.left,
      );

  String get _resultText {
    final String filter = booksCtrl.searchController.text;
    String result = widget.book.text ?? '';
    if (filter.isEmpty) return result;
    if (widget.book.text == null) return result;
    result = result.replaceAll(filter, '<primary>$filter<primary>');
    result = result.replaceAll(filter.toLowerCase(), '<primary>${filter.toLowerCase()}<primary>');
    result = result.replaceAll(filter.toUpperCase(), '<primary>${filter.toUpperCase()}<primary>');
    result = result.replaceAll(
      filter.substring(0, 1).toUpperCase() + filter.substring(1).toLowerCase(),
      '<primary>${filter.substring(0, 1).toUpperCase() + filter.substring(1).toLowerCase()}<primary>',
    );
    result = result.replaceAll('<primary><primary>', '<primary>');
    return result;
  }

  Widget _locations() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SelectableText(
            'Locations:',
            style: TextStyle(
              fontSize: 12,
              height: 18 / 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.book.locations.length,
            itemBuilder: (_, int i) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  ' - ',
                  style: TextStyle(
                    fontSize: 12,
                    height: 18 / 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: SelectableText(
                    '${widget.book.locations[i].area ?? ''}: ${widget.book.locations[i].subArea ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 18 / 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.left,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _toggleViewButton() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _toggleView,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            child: Icon(
              expandedView ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
              size: 17,
            ),
          ),
        ),
      );

  void _toggleView() => setState(() => expandedView = !expandedView);
}
