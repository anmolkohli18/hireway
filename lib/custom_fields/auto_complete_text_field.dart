import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField(
      {super.key,
      required this.textFieldKey,
      required this.kOptions,
      required this.onChanged,
      required this.preSelectedOption});
  final Key textFieldKey;
  final Future<List<String>> kOptions;
  final Function(String) onChanged;
  final String preSelectedOption;

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  String _selectedOption = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedOption = widget.preSelectedOption;
    });
  }

  Widget selectedOptionWidget(String selectedOption) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(10.0),
        child: Text(selectedOption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: widget.kOptions,
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
              _selectedOption.isEmpty
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
                          _selectedOption = selection! as String;
                        });
                        widget.onChanged(_selectedOption);
                      },
                    )
                  : selectedOptionWidget(_selectedOption),
            ],
          );
        });
  }
}
