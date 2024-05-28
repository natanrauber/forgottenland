import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenland/modules/books/controllers/books_controller.dart';
import 'package:forgottenland/modules/books/views/components/book_widget.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/theme/theme.dart';
import 'package:forgottenland/views/widgets/src/fields/custom_text_field.widget.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:forgottenland/views/widgets/src/other/error_builder.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class BooksPage extends StatefulWidget {
  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  BooksController booksCtrl = Get.find<BooksController>();

  Timer searchTimer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'books',
        postFrameCallback: booksCtrl.getAll,
        onRefresh: booksCtrl.getAll,
        body: Column(
          children: <Widget>[
            _title(),
            _divider(),
            _searchBar(),
            const SizedBox(height: 10),
            _body(),
          ],
        ),
      );

  Widget _title() => SelectableText(
        'Rookgaard Books',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: const Divider(height: 1),
      );

  Widget _searchBar() => CustomTextField(
        loading: booksCtrl.isLoading.isTrue,
        label: 'Search',
        controller: booksCtrl.searchController,
        onChanged: (_) {
          if (searchTimer.isActive) searchTimer.cancel();

          searchTimer = Timer(
            const Duration(milliseconds: 500),
            () => booksCtrl.filterList(),
          );
        },
      );

  Widget _body() => Obx(
        () {
          if (booksCtrl.isLoading.value) return _loading();
          if (booksCtrl.response.error) {
            return ErrorBuilder(
              'Internal server error',
              reloadButtonText: 'Try again',
              onTapReload: booksCtrl.getAll,
            );
          }
          return _listBuilder();
        },
      );

  Widget _loading() => Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(35),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
        ),
      );

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: booksCtrl.books.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final Book book = booksCtrl.books[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: BookWidget(book),
    );
  }
}
