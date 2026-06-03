import 'package:flutter/material.dart';
import 'package:meal_recipes_flutter/data/dummy_data.dart';
import 'package:meal_recipes_flutter/models/meal.dart';
import 'package:meal_recipes_flutter/models/settings.dart';

//Screens
import 'screens/meal_detail_screen.dart';
import 'screens/categories_meals_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/settings_screen.dart';

//Utils
import 'utils/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Settings settings = Settings();
  List<Meal> _availableMeals = dummyMeals;
  List<Meal> _favoriteMeals = [];

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;

      _availableMeals = dummyMeals.where((meal) {
        final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;
        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      routes: {
        AppRoutes.home: (ctx) => TabsScreen(favoriteMeals: _favoriteMeals),
        AppRoutes.categoriesMeals: (ctx) => CategoriesMealsScreen(meals: _availableMeals),
        AppRoutes.mealDetail: (ctx) => MealDetailScreen(onToggleFavorite: _toggleFavorite, isFavorite: _isFavorite),
        AppRoutes.settings: (ctx) => SettingsScreen(onSettingsChanged: _filterMeals, settings: settings),
      },
      // onGenerateRoute: (settings) {

      // },
      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       return const CategoriesScreen();
      //     },
      //   );
      // },
    );
  }
}
