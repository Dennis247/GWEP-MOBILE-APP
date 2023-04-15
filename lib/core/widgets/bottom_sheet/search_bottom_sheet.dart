// ignore_for_file: prefer_final_fields

import 'package:RefApp/core/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import '/core/utils/colors.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchBottomSheet extends StatefulWidget {
  final List<String> sourceList;
  final String title;

  const SearchBottomSheet(
      {Key? key, required this.sourceList, required this.title})
      : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SearchBottomSheetViewModel>();
    vm.setOriginalList(widget.sourceList);
    return Consumer<SearchBottomSheetViewModel>(
      builder: ((context, value, child) => SizedBox(
            height: 80.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //    const Dragger(),
                SizedBox(height: 2.5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 2.0.h, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 2.5.h),
                CustomTextField(
                  textEditingController: _searchController,
                  lableText: 'Search for options',
                  onChanged: (text) {
                    value.filterList(text);
                  },
                  // prefixIcon: Icon(
                  //   Icons.search,
                  //   size: 20.sp,
                  // ),
                ),
                SizedBox(height: 2.5.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: value.filteredList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          value.setSelectedItem(value.filteredList[index]);
                          Navigator.of(context).pop(value.filteredList[index]);
                        },
                        child: _SearchItemTile(
                          item: value.filteredList[index],
                          isSelected:
                              value.filteredList[index] == value.selectedItem,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        color: AppColors.grayLightest2,
                        height: 1,
                      );
                    },
                  ),
                ),
                SizedBox(height: 2.5.h),
              ],
            ),
          )),
    );
  }
}

class _SearchItemTile extends StatelessWidget {
  final String item;
  final bool isSelected;
  const _SearchItemTile(
      {Key? key, required this.item, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.circle : Icons.circle_outlined,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 3.w),
          Text(
            item,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SearchBottomSheetViewModel extends ChangeNotifier {
  String? _selectedItem = "";
  String get selectedItem => _selectedItem!;

  List<String> _filteredList = [];
  List<String> get filteredList => _filteredList;

  List<String> _originalList = [];
  List<String> get originalList => _originalList;

  setOriginalList(List<String> list) {
    _originalList = list;
    _filteredList = _originalList;
  }

  setSelectedItem(String value) {
    _selectedItem = value;
  }

  void clearSelectedItem() {
    _selectedItem = "";
  }

  void filterList(String value) {
    if (value.isEmpty) {
      _filteredList = _originalList;
    } else {
      _filteredList = _originalList
          .where((element) =>
              element.toLowerCase().contains(value.toLowerCase()) ||
              element.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}
