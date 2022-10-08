import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteMultiTextField extends StatefulWidget {
  const AutoCompleteMultiTextField(
      {super.key,
      required this.textFieldKey,
      required this.kOptions,
      required this.onChanged});
  final Key textFieldKey;
  final Stream<List<String>> kOptions;
  final Function(List<String>) onChanged;

  @override
  State<AutoCompleteMultiTextField> createState() =>
      _AutoCompleteMultiTextFieldState();
}

class _AutoCompleteMultiTextFieldState
    extends State<AutoCompleteMultiTextField> {
  List<String> selectedOptions = [];
  List<Widget> selectedOptionsWidget = [];

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

          final List<String> options = snapshot.hasData
              ? snapshot.requireData
              : ["Anmol Kohli <anmol.kohli18@gmail.com>"];
          final TextEditingController typeAheadController =
              TextEditingController();

          print(options.length);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeAheadFormField(
                key: widget.textFieldKey,
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
                    selectedOptions.add(selection! as String);
                    selectedOptionsWidget.add(Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        padding: const EdgeInsets.all(4.0),
                        child: Text(selection as String),
                      ),
                    ));
                  });
                  widget.onChanged(selectedOptions);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ...selectedOptionsWidget
            ],
          );
        });
  }
}
