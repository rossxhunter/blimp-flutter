import 'package:blimp/screens/settings/settings_section.dart';
import 'package:blimp/screens/settings/settings_tile.dart';
import 'package:blimp/screens/settings/setttings_list.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recase/recase.dart';
import 'package:bot_toast/src/toast_widget/animation.dart';

class SettingsPage extends StatefulWidget {
  final Function logoutCallback;
  SettingsPage({this.logoutCallback});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState(logoutCallback: logoutCallback);
  }
}

class SettingsPageState extends State<SettingsPage> {
  final Function logoutCallback;
  SettingsPageState({this.logoutCallback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: SettingsList(
          sections: _getSettingsSections(context),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  List<SettingsSection> _getSettingsSections(BuildContext context) {
    List<SettingsSection> sections = [];
    if (isLoggedIn == true) {
      sections.add(
        SettingsSection(
          title: 'Profile',
          tiles: [
            SettingsTile(
              title: 'First Name',
              subtitle: 'Ross',
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Last Name',
              subtitle: 'Hunter',
              leading: Icon(Icons.people),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Sign In Method',
              subtitle: 'Email',
              leading: Icon(FontAwesomeIcons.signInAlt),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Email',
              subtitle: 'ross98hunter@gmail.com',
              leading: Icon(Icons.email),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Password',
              subtitle: '******',
              leading: Icon(Icons.lock),
              onTap: () {},
            ),
          ],
        ),
      );
    }
    if (isLoggedIn) {
      sections.add(SettingsSection(title: 'Booking', tiles: [
        SettingsTile(
          title: 'Payment Cards',
          subtitle: '2 Cards',
          leading: Icon(Icons.credit_card),
          onTap: () {},
        ),
        SettingsTile(
          title: 'Travellers',
          subtitle:
              currentUser["travellers"].length.toString() + ' Traveller(s)',
          leading: Icon(Icons.people),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPageChange(
                  option: "travellers",
                ),
              ),
            ).then((value) => setState(() {}));
          },
        ),
      ]));
    }
    sections.add(
      SettingsSection(
        title: 'Explore Page',
        tiles: [
          SettingsTile(
            title: 'Home City',
            subtitle: 'London',
            leading: Icon(
              Icons.location_city,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Max Budget',
            subtitle: '£3000',
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
    sections.add(
      SettingsSection(
        title: 'Localization',
        tiles: [
          SettingsTile(
            title: 'Country',
            subtitle: 'United Kingdom',
            leading: Icon(
              Icons.language,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(
              FontAwesomeIcons.language,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Currency',
            subtitle: 'GBP',
            leading: Icon(
              FontAwesomeIcons.moneyBill,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
    sections.add(
      SettingsSection(
        title: 'Other',
        tiles: [
          SettingsTile(
            title: 'About',
            // subtitle: 'United Kingdom',
            leading: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Help',
            // subtitle: 'English',
            leading: Icon(
              Icons.help,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Contact',
            // subtitle: 'GBP',

            leading: Icon(
              Icons.email,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Feedback',
            // subtitle: 'GBP',
            leading: Icon(
              Icons.feedback,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
    if (isLoggedIn) {
      sections.add(
        SettingsSection(
          title: '',
          tiles: [
            SettingsTile(
              title: 'Logout',
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                isLoggedIn = false;
                Navigator.pop(context);
                logoutCallback();
              },
            ),
          ],
        ),
      );
    }
    return sections;
  }
}

class SettingsPageChange extends StatefulWidget {
  final Function callback;
  final String option;
  final Map fields;
  SettingsPageChange({this.callback, this.option, this.fields});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageChangeState(option: option, fields: fields);
  }
}

class SettingsPageChangeState extends State<SettingsPageChange> {
  final String option;
  final Map fields;
  Map formValues = Map();
  SettingsPageChangeState({this.option, this.fields});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // ReCase(option).titleCase,
          "Settings",
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white),
        ),
        actions: _getActions(),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Stack(
            children: [
              _getSettingsPageChangeBody(widget.callback, context, fields),
              // Positioned(
              //   bottom: 30,
              //   left: 0,
              //   right: 0,
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: SaveButton(option: option),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateFormValues(String field, dynamic value) {
    setState(() {
      formValues[field] = value;
    });
  }

  List<Widget> _getActions() {
    if (option == "travellers") {
      return [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: AnimatedButton(
            callback: () {
              addNewTraveller().then((value) {
                setState(() {
                  currentUser["travellers"] = value;
                });
                showSuccessToast(context, "New traveller added");
              });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ];
    }
  }

  void updateState() {
    setState(() {});
    showSuccessToast(context, "Saved");
  }

  List<SettingsSection> _getTravellersSections(BuildContext context) {
    List<SettingsSection> sections = [];
    int i = 0;
    for (Map t in currentUser["travellers"]) {
      i += 1;
      sections.add(
        SettingsSection(
          title: 'Traveller ' + i.toString(),
          tiles: [
            SettingsTile(
              title: 'Full Name',
              subtitle: t["fullName"] != null ? t["fullName"] : "Not Set",
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: updateState,
                        option: "travellerFullName",
                        fields: {"traveller": t["id"]}),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Date of Birth',
              subtitle: t["DOB"] != null ? t["DOB"] : "Not Set",
              leading: Icon(FontAwesomeIcons.calendar),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: updateState,
                        option: "travellerDob",
                        fields: {"traveller": t["id"]}),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Sex',
              subtitle: t["sex"] == "M"
                  ? "Male"
                  : t["sex"] == "F" ? "Female" : "Not Set",
              leading: Icon(FontAwesomeIcons.venusMars),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: updateState,
                        option: "travellerSex",
                        fields: {"traveller": t["id"]}),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Address',
              subtitle:
                  t["streetAddress"] != null ? t["streetAddress"] : "Not Set",
              leading: Icon(Icons.location_on),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: updateState,
                        option: "travellerAddress",
                        fields: {"traveller": t["id"]}),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Passport Number',
              subtitle:
                  t["passportNumber"] != null ? t["passportNumber"] : "Not Set",
              leading: Icon(FontAwesomeIcons.passport),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: updateState,
                        option: "travellerPassportNumber",
                        fields: {"traveller": t["id"]}),
                  ),
                );
              },
            ),
            // SettingsTile(
            //   title: 'Edit',
            //   leading: Icon(
            //     Icons.edit,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   onTap: () {
            //     removeTraveller(t["id"]).then((value) {
            //       setState(() {
            //         currentUser["travellers"] = value;
            //       });
            //     });
            //   },
            // ),
            SettingsTile(
              title: 'Delete',
              leading: Icon(
                Icons.remove_circle,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                removeTraveller(t["id"]).then((value) {
                  setState(() {
                    currentUser["travellers"] = value;
                  });
                  showSuccessToast(context, "Traveller deleted");
                });
              },
            ),
          ],
        ),
      );
    }
    return sections;
  }

  Widget _getSettingsPageChangeBody(
      Function callback, BuildContext context, Map fields) {
    if (option == "travellers") {
      return SettingsList(
        sections: _getTravellersSections(context),
      );
    } else {
      GlobalKey _formKey = GlobalKey<FormState>();
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: SettingsPageChangeForm(
              option: option,
              fields: fields,
              formKey: _formKey,
              callback: _updateFormValues,
            ),
          ),
          Positioned(
            bottom: 30,
            child: SaveButton(
              callback: callback,
              option: option,
              fields: fields,
              formKey: _formKey,
              formValues: formValues,
            ),
          ),
        ],
      );
    }
  }
}

class SettingsPageChangeForm extends StatefulWidget {
  final String option;
  final Map fields;
  final GlobalKey<FormState> formKey;
  final Function callback;
  SettingsPageChangeForm(
      {this.option, this.fields, this.callback, this.formKey});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageChangeFormState(
        option: option, fields: fields, callback: callback, formKey: formKey);
  }
}

class SettingsPageChangeFormState extends State<SettingsPageChangeForm> {
  String option;
  Map fields;
  Function callback;
  GlobalKey<FormState> formKey;
  SettingsPageChangeFormState(
      {this.option, this.fields, this.callback, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: _getSettingsPageFormFields(),
      ),
    );
  }

  List<Widget> _getSettingsPageFormFields() {
    if (option == "travellerPassportNumber") {
      return [
        TextFormField(
          initialValue: currentUser["travellers"].firstWhere(
              (t) => t["id"] == fields["traveller"])["passportNumber"],
          decoration: InputDecoration(
            labelText: 'Passport Number',
            prefixIcon: Icon(FontAwesomeIcons.passport),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            fillColor: Color.fromRGBO(245, 245, 245, 1),
            filled: true,
          ),
          onSaved: (value) => callback("passportNumber", value),
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter the passport number";
            }
            return null;
          },
        ),
      ];
    }
    if (option == "travellerFullName") {
      return [
        TextFormField(
          initialValue: currentUser["travellers"]
              .firstWhere((t) => t["id"] == fields["traveller"])["fullName"],
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(FontAwesomeIcons.user),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            fillColor: Color.fromRGBO(245, 245, 245, 1),
            filled: true,
          ),
          onSaved: (value) => callback("fullName", value),
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter the full name";
            }
            return null;
          },
        ),
      ];
    } else if (option == "travellerAddress") {
      return [
        TextFormField(
          initialValue: currentUser["travellers"].firstWhere(
              (t) => t["id"] == fields["traveller"])["streetAddress"],
          decoration: InputDecoration(
            labelText: 'Street Address',
            prefixIcon: Icon(FontAwesomeIcons.home),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            fillColor: Color.fromRGBO(245, 245, 245, 1),
            filled: true,
          ),
          onSaved: (value) => callback("streetAddress", value),
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter the street address";
            }
            return null;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TextFormField(
            initialValue: currentUser["travellers"]
                .firstWhere((t) => t["id"] == fields["traveller"])["city"],
            decoration: InputDecoration(
              labelText: 'City/Town',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
            ),
            onSaved: (value) => callback("city", value),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter the city";
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TextFormField(
            initialValue: currentUser["travellers"]
                .firstWhere((t) => t["id"] == fields["traveller"])["region"],
            decoration: InputDecoration(
              labelText: 'State/Province/County/Region',
              prefixIcon: Icon(FontAwesomeIcons.searchLocation),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
            ),
            onSaved: (value) => callback("region", value),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter the region";
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TextFormField(
            initialValue: currentUser["travellers"]
                .firstWhere((t) => t["id"] == fields["traveller"])["postcode"],
            decoration: InputDecoration(
              labelText: 'Postcode/ZIP Code',
              prefixIcon: Icon(FontAwesomeIcons.locationArrow),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
            ),
            onSaved: (value) => callback("postcode", value),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter the postcode";
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TextFormField(
            initialValue: currentUser["travellers"]
                .firstWhere((t) => t["id"] == fields["traveller"])["country"],
            decoration: InputDecoration(
              labelText: 'Country',
              prefixIcon: Icon(Icons.language),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
            ),
            onSaved: (value) => callback("country", value),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter the country";
              }
              return null;
            },
          ),
        ),
      ];
    }
  }
}

class SaveButton extends StatelessWidget {
  final Function callback;
  final String option;
  final GlobalKey<FormState> formKey;
  final Map formValues;
  final Map fields;
  SaveButton(
      {this.callback, this.option, this.formKey, this.formValues, this.fields});
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          if (option == "travellerAddress") {
            updateTravellerAddress(fields["traveller"], formValues)
                .then((value) {
              currentUser["travellers"] = value;
              callback();
              Navigator.pop(context);
            });
          }
        }
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromRGBO(
          //         (Theme.of(context).primaryColor.red * 0.8).round(),
          //         (Theme.of(context).primaryColor.green * 0.8).round(),
          //         (Theme.of(context).primaryColor.blue * 0.8).round(),
          //         1),
          //     blurRadius: 0.0,
          //     spreadRadius: 0,
          //     offset: Offset(0, 5),
          //   )
          // ],
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 10.0,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Save",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
