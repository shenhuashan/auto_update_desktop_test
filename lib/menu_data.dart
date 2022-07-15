// // To parse this JSON data, do
// //
// //     final menu = menuFromJson(jsonString);

// import 'dart:convert';

// Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

// String menuToJson(Menu data) => json.encode(data.toJson());

// class Menu {
//   Menu({
//     this.items,
//   });

//   List<Item>? items;

//   factory Menu.fromJson(Map<String, dynamic> json) => Menu(
//         items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "items": List<dynamic>.from(items ?? [].map((x) => x.toJson())),
//       };
// }

// class Item {
//   Item({
//     this.menuitem,
//   });

//   MenuItem? menuitem;

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         menuitem: MenuItem.fromJson(json["menuitem"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "menuitem": menuitem?.toJson(),
//       };
// }

// class MenuItem {
//   MenuItem({
//     this.key,
//     this.label,
//   });

//   String? key;
//   String? label;

//   factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
//         key: json["key"],
//         label: json["label"],
//       );

//   Map<String, dynamic> toJson() => {
//         "key": key,
//         "label": label,
//       };
// }
