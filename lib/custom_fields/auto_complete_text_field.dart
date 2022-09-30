import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField({super.key, required this.kOptions});
  final Stream<List<String>> kOptions;

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  List<Text> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
        stream: widget.kOptions,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final List<String> options =
              snapshot.hasData ? snapshot.requireData : [""];
          final TextEditingController typeAheadController =
              TextEditingController();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: typeAheadController,
                    decoration: const InputDecoration(
                        hintText: 'Start typing to get suggestions')),
                suggestionsCallback: (textEditingValue) {
                  if (textEditingValue.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return options.where((option) => option
                      .toLowerCase()
                      .startsWith(textEditingValue.toLowerCase()));
                },
                itemBuilder: (context, itemData) {
                  return ListTile(
                    title: Text(itemData! as String),
                  );
                },
                onSuggestionSelected: (selection) {
                  setState(() {
                    selectedOptions.add(Text(selection! as String));
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ...selectedOptions
            ],
          );
        });
  }
}
