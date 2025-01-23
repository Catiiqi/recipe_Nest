import 'package:flutter/material.dart';
import 'package:recipenest/util/provider/recipe_provider.dart';

class MyRadioButton extends StatefulWidget {
  final FoodCatogory? initialCharacter;
  final ValueChanged<FoodCatogory?> onCategorySelected;

  const MyRadioButton({super.key, this.initialCharacter ,required this.onCategorySelected});

  @override
  State<MyRadioButton> createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton> {
  FoodCatogory? selectedCategory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategory = widget.initialCharacter ?? FoodCatogory.vegetarian;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('vegetarian'),
          leading: Radio<FoodCatogory>(
            value: FoodCatogory.vegetarian,
            groupValue: selectedCategory,
            onChanged: (FoodCatogory? value) {
              setState(() {
                selectedCategory = value;
                widget.onCategorySelected(selectedCategory);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('omnivorous'),
          leading: Radio<FoodCatogory>(
            value: FoodCatogory.omnivorous,
            groupValue: selectedCategory,
            onChanged: (FoodCatogory? value) {
              setState(() {
                selectedCategory = value;
                widget.onCategorySelected(selectedCategory);

              });
            },
          ),
        ),
        ListTile(
          title: const Text('Drinks'),
          leading: Radio<FoodCatogory>(
            value: FoodCatogory.drinks,
            groupValue: selectedCategory,
            onChanged: (FoodCatogory? value) {
              setState(() {
                selectedCategory = value;
                widget.onCategorySelected(selectedCategory);

              });
            },
          ),
        ),
        ListTile(
          title: const Text('Deserts'),
          leading: Radio<FoodCatogory>(
            value: FoodCatogory.deserts,
            groupValue: selectedCategory,
            onChanged: (FoodCatogory? value) {
              setState(() {
                selectedCategory = value;
                widget.onCategorySelected(selectedCategory);

              });
            },
          ),
        ),
      ],
    );
  }
}
