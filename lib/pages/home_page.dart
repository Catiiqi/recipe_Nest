import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/util/recipe_page_tile.dart';
import '../util/provider/recipe_provider.dart';
import 'add_recipe_page.dart';
import '/pages/profile_page.dart';
import '/util/recipe_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    
    final recipeProvider = Provider.of<RecipeProvider>(context);
    Future<void> _refreshRecipes() async {
      await recipeProvider.fetchRecipes(); // Trigger fetching recipes again
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Menu",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 10,
            ),
            TabBar(
              indicatorAnimation: TabIndicatorAnimation.linear,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              onTap: (index) {
                // Update the category when a tab is tapped
                switch (index) {
                  case 0:
                    recipeProvider.setCategory('all');
                    break;
                  case 1:
                    recipeProvider.setCategory('vegetarian');
                    break;
                  case 2:
                    recipeProvider.setCategory('omnivorous');
                    break;
                  case 3:
                    recipeProvider.setCategory('drinks');
                    break;
                  case 4:
                    recipeProvider.setCategory('deserts');
                    break;
                }
              },
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Vegetarian'),
                Tab(text: 'Omnivorous'),
                Tab(text: 'drinks'),
                Tab(text: 'deserts'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: recipeProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : recipeProvider.filteredRecipes.isEmpty
                      ? Center(child: Text('No recipes found.'))
                      : RefreshIndicator(
                          onRefresh: _refreshRecipes,
                          child: ListView.builder(
                            itemCount: recipeProvider.filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe =
                                  recipeProvider.filteredRecipes[index];
                              return recipeProvider.isLoading
                                  ? CircularProgressIndicator()
                                  : RecipeTile(
                                      name: recipe['recipeName'] ?? 'Unknown',
                                      imageUrl:
                                          recipe['profileImage'] ?? 'no image',
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipePageTile(
                                                    recipeId: recipe['id'],
                                                    recipeImage: recipe[
                                                            'profileImage'] ??
                                                        'no image',
                                                    recipeName:
                                                        recipe['recipeName'],
                                                    recipeIngrident: recipe[
                                                        'recipeIngrident'],
                                                    recipeSteps:
                                                        recipe['recipeSteps'],
                                                  ))),
                                      deleteFunction: (context) {
                                        recipeProvider
                                            .deleteRecipe(recipe['id']);
                                      },
                                    );
                            },
                          ),
                        ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddRecipePage()));
                break;

              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));

                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Recipe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
