import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField(
      {super.key,
      required this.textFieldKey,
      required this.kOptions,
      required this.onChanged});
  final Key textFieldKey;
  final Stream<List<String>> kOptions;
  final Function(String) onChanged;

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  String selectedOption = "";
  Widget selectedOptionWidget = Container();

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
              selectedOption.isEmpty
                  ? TypeAheadFormField(
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
                          selectedOption = selection! as String;
                          selectedOptionWidget = Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              padding: const EdgeInsets.all(10.0),
                              child: Text(selectedOption),
                            ),
                          );
                        });
                        widget.onChanged(selectedOption);
                      },
                    )
                  : selectedOptionWidget,
            ],
          );
        });
  }
}
