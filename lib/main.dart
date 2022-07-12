import 'package:desktop_test/country_page.dart';
import 'package:desktop_test/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AutoCompleteDemo(),
    );
  }
}

const List<Country> countryOptions = <Country>[
  Country(name: 'Africa', size: 30370000),
  Country(name: 'Asia', size: 44579000),
  Country(name: 'Australia', size: 8600000),
  Country(name: 'Bulgaria', size: 110879),
  Country(name: 'Canada', size: 9984670),
  Country(name: 'Denmark', size: 42916),
  Country(name: 'Europe', size: 10180000),
  Country(name: 'India', size: 3287263),
  Country(name: 'North America', size: 24709000),
  Country(name: 'South America', size: 17840000),
];

class AutoCompleteDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter Version 1.0.0'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Autocomplete<Country>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return countryOptions
                .where((Country county) => county.name
                    .toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase()))
                .toList();
          },
          displayStringForOption: (Country option) => option.name,
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          onSelected: (Country selection) {
            print('Selected: ${selection.name}');
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<Country> onSelected,
              Iterable<Country> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 600,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Country option = options.elementAt(index);

                      return ListTile(
                        onTap: (){
                        onSelected(option);

                        },
                        title: Text(
                          option.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        hoverColor: Colors.red,
                        focusColor: Colors.blueGrey,
                        tileColor: Colors.blue,
                        enabled: true,
                        focusNode: FocusNode(),
                        
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
