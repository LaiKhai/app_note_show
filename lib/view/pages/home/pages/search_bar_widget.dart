import '../../../../index.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final BottomSheetModal bottomSheetModal = di.get();
  final HomePageImpl homePageImpl = di.get();
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppMargin.m8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorName.colorGrey3,
      ),
      child: TextFormField(
        controller: searchController,
        focusNode: searchFocusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'search text',
          hintStyle: const TextStyle(color: ColorName.colorGrey2),
          prefixIcon: IconButton(
            onPressed: () {
              if (searchController.text != "") {
                homePageImpl.searchTitle(searchController.text);
                setState(() {
                  isSearch = true;
                });
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.search),
            color: ColorName.colorGrey2,
          ),
          suffixIcon: isSearch
              ? IconButton(
                  onPressed: () {
                    if (searchController.text != "") {
                      homePageImpl.load();
                      searchController.clear();
                      if (searchFocusNode.hasFocus) searchFocusNode.unfocus();
                      setState(() {
                        isSearch = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.close),
                  color: ColorName.colorGrey2,
                )
              : IconButton(
                  onPressed: () {
                    bottomSheetModal.showBottomSheet(
                        context, bottomSheetModal.buildBottomSheet(setState),
                        padding: const EdgeInsetsDirectional.all(AppSize.s16));
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                  color: ColorName.colorGrey2,
                ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
