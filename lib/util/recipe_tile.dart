
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/util/mybutton.dart';

import 'provider/recipe_provider.dart';

class RecipeTile extends StatelessWidget {
  final void Function()? onTap;
  final String name;
  final String imageUrl;
  final Function(BuildContext)? deleteFunction;
 const RecipeTile(
      {super.key,
      required this.onTap,
      required this.name,
      this.deleteFunction,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Slidable(
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          onPressed: deleteFunction,
          icon: Icons.delete,
          backgroundColor: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
          autoClose: true,
          spacing: 2,
        )
      ]),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.amber.shade100,
                    offset: const Offset(5, 5),
                    blurRadius: 10.0,
                    spreadRadius: 2.0),
                BoxShadow(
                  color: Theme.of(context).colorScheme.background,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                )
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 0)),
          height: 200,
          width: 390,
          margin: EdgeInsets.only(bottom: 20, left: 10, right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl == 'no image'
                  ? Placeholder(
                      color: Colors.grey,
                      fallbackHeight: 100,
                    )
                  : recipeProvider.isLoading
                      ? Center(
                        heightFactor: 4,
                          child: CircularProgressIndicator(),
                        )
                      : ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Image.network(
                            
                            imageUrl,
                            height: 170,
                            width: 400,
                            fit: BoxFit.cover,
                            
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null),
                              );
                            },
                          )),
              Mytext(
                text: name,
                color: Colors.black,
                fontSize: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
