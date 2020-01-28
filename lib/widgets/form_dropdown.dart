import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:app/widgets/text_field_arg.dart';

import '../style_provider.dart';

class FormDropdown extends StatelessWidget {
  const FormDropdown({
    Key key,
    this.hintText,
    this.labelText,
    this.onChanged,
    @required this.items,
    @required this.attribute,
  }) : super(key: key);

  final String hintText;
  final String attribute;
  final String labelText;
  final Function onChanged;
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            labelText,
            style: StylesProvider.of(context).fonts.normalBlue,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: FormBuilderDropdown(
            isDense: true,
            underline: Container(
              color: StylesProvider.of(context).colors.orange,
            ),
            iconSize: 15,
            icon: Image.asset('assets/down-arrow.png'),
            attribute: attribute,
            decoration: inputDecoration(context),
            hint: Text(
              hintText,
              style: StylesProvider.of(context)
                  .fonts
                  .lightBlueLowOpacity
                  .copyWith(fontSize: 13),
            ),
            validators: [FormBuilderValidators.required()],
            onChanged: onChanged,
            items: items
                .map(
                  (String item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text(
                      "$item",
                      style: StylesProvider.of(context)
                          .fonts
                          .normalBlue
                          .copyWith(fontSize: 13),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
