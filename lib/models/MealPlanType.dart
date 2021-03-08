class MealPlanType {
  int id;
  String type;
  int planMealId;
  int portion;
  String hour;
  List<dynamic> ingredients;
  bool opened;

  MealPlanType();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'planMealId': planMealId,
        'portion': portion,
        'hour': hour,
        'ingredients': ingredients
      };

  MealPlanType.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        planMealId = json['planMealId'],
        portion = json['portion'],
        hour = json['hour'],
        ingredients = json['ingredients'],
        opened = false,
        id = json['id'];
}