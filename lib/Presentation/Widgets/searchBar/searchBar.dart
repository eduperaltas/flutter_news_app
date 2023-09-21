import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchTextChanged;
  final VoidCallback onFilterPressed;
  final String filtersLen;

  const CustomSearchBar({
    required this.searchController,
    required this.onSearchTextChanged,
    required this.onFilterPressed,
    required this.filtersLen,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        controller: searchController,
        onChanged: onSearchTextChanged,
        // cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded),
          // prefixIconColor: Theme.of(context).primaryColor,
          suffixIcon: IconButton(
            onPressed: onFilterPressed,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                if (filtersLen != '0')
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        filtersLen,
                        style: const TextStyle(
                          fontFamily: 'Gilroy_semibold',
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
