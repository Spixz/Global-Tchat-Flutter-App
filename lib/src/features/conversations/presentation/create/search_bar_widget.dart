import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) updateQueryAndSearch;
  const SearchBar({super.key, required this.updateQueryAndSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (value) => updateQueryAndSearch(value),
      ),
    );
  }
}
