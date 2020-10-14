import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/settings/settings_section.dart';
import 'package:blimp/screens/settings/settings_tile.dart';
import 'package:blimp/screens/settings/setttings_list.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: CustomColors.greyBackground,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
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
              title: 'Name',
              subtitle:
                  currentUser["firstName"] + " " + currentUser["lastName"],
              leading: Icon(
                FontAwesomeIcons.solidUser,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      option: "name",
                      type: "user",
                      callback: () {
                        setState(() {});
                        showSuccessToast(context, "Saved");
                      },
                      formFields: [
                        CustomField(
                          type: CustomFieldType.text,
                          field: "firstName",
                          initialValue: currentUser["firstName"],
                          labelText: 'First Name',
                          prefixIcon: FontAwesomeIcons.solidUser,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                        ),
                        CustomField(
                          type: CustomFieldType.text,
                          field: "lastName",
                          initialValue: currentUser["lastName"],
                          labelText: 'Last Name',
                          prefixIcon: FontAwesomeIcons.solidUser,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ).then(
                  (value) => setState(() {}),
                );
              },
            ),
            SettingsTile(
              title: 'Email',
              subtitle: currentUser["email"],
              leading: Icon(
                FontAwesomeIcons.solidEnvelope,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      option: "email",
                      type: "user",
                      callback: () {
                        setState(() {});
                        showSuccessToast(context, "Saved");
                      },
                      formFields: [
                        CustomField(
                          type: CustomFieldType.text,
                          field: "email",
                          initialValue: currentUser["email"],
                          labelText: 'Email',
                          prefixIcon: FontAwesomeIcons.solidUser,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ).then(
                  (value) => setState(() {}),
                );
              },
            ),
            SettingsTile(
              title: 'Password',
              subtitle: '******',
              leading: Icon(
                FontAwesomeIcons.lock,
                color: Theme.of(context).primaryColor,
              ),
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
          leading: Icon(
            FontAwesomeIcons.creditCard,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {},
        ),
        SettingsTile(
          title: 'Travellers',
          subtitle:
              currentUser["travellers"].length.toString() + ' Traveller(s)',
          leading: Icon(
            FontAwesomeIcons.users,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPageTravellersChange(),
              ),
            ).then((value) => setState(() {}));
          },
        ),
      ]));
    }
    sections.add(
      SettingsSection(
        title: 'Trips',
        tiles: [
          SettingsTile(
            title: 'Home City',
            subtitle: 'London',
            leading: Icon(
              FontAwesomeIcons.city,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Max Budget',
            subtitle: '£3000',
            leading: Icon(
              FontAwesomeIcons.coins,
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
              FontAwesomeIcons.globe,
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
            title: 'Leave a Review',
            leading: Icon(
              FontAwesomeIcons.solidStar,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Contact',
            leading: Icon(
              FontAwesomeIcons.solidEnvelope,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Help',
            leading: Icon(
              FontAwesomeIcons.solidQuestionCircle,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'About',
            leading: Icon(
              FontAwesomeIcons.infoCircle,
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
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                isLoggedIn = false;
                currentUser = null;
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
  final String type;
  final String option;
  final Map fields;
  final List<CustomField> formFields;
  SettingsPageChange(
      {this.callback, this.type, this.option, this.fields, this.formFields});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageChangeState(
        option: option, fields: fields, type: type, formFields: formFields);
  }
}

class SettingsPageChangeState extends State<SettingsPageChange> {
  final String option;
  final String type;
  final Map fields;
  final List<CustomField> formFields;
  Map formValues = Map();
  SettingsPageChangeState(
      {this.option, this.type, this.fields, this.formFields});

  @override
  Widget build(BuildContext context) {
    GlobalKey _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: CustomColors.greyBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: AutoSizeText(
          ReCase(option).titleCase,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: SettingsPageChangeForm(
                  option: option,
                  fields: fields,
                  formKey: _formKey,
                  callback: _updateFormValues,
                  formFields: formFields,
                ),
              ),
              Positioned(
                bottom: 30,
                child: SaveButton(
                  callback: widget.callback,
                  type: type,
                  fields: fields,
                  formKey: _formKey,
                  formValues: formValues,
                ),
              ),
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
}

class SettingsPageTravellersChange extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageTravellersChangeState();
  }
}

class SettingsPageTravellersChangeState
    extends State<SettingsPageTravellersChange> {
  List travellers;
  @override
  void initState() {
    travellers = currentUser["travellers"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greyBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: AutoSizeText(
          "Travellers",
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: AnimatedButton(
              callback: () {
                addNewTraveller().then((value) {
                  currentUser["travellers"] = value;
                  updateState();
                  showSuccessToast(context, "New traveller added");
                });
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SettingsList(
        sections: _getTravellersSections(context, travellers),
      ),
    );
  }

  void saveState() {
    updateState();
    showSuccessToast(context, "Saved");
  }

  void updateState() {
    setState(() {
      travellers = currentUser["travellers"];
    });
  }

  List<SettingsSection> _getTravellersSections(
      BuildContext context, List travellers) {
    List<SettingsSection> sections = [];
    int i = 0;
    for (Map traveller in travellers) {
      i += 1;
      sections.add(
        SettingsSection(
          title: 'Traveller ' + i.toString(),
          tiles: [
            SettingsTile(
              title: 'Full Name',
              subtitle: traveller["fullName"] != null
                  ? traveller["fullName"]
                  : "Not Set",
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      callback: saveState,
                      option: "fullName",
                      type: "traveller",
                      fields: {"traveller": traveller["id"]},
                      formFields: [
                        CustomField(
                          field: "fullName",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) => t["id"] == traveller["id"])["fullName"],
                          labelText: 'Full Name',
                          prefixIcon: FontAwesomeIcons.user,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the full name";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Date of Birth',
              subtitle: traveller["dob"] != null
                  ? DateFormat("d MMMM y")
                      .format(DateTime.parse(traveller["dob"]))
                  : "Not Set",
              leading: Icon(FontAwesomeIcons.calendar),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SettingsPageChange(
                //         callback: updateState,
                //         option: "travellerDob",
                //         type: "traveller",
                //         fields: {"traveller": traveller["id"]}),
                //   ),
                // );
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime.now(),
                  onChanged: (date) {
                    print('change $date');
                  },
                  onConfirm: (date) {
                    updateTraveller(traveller["id"], {
                      "dob": DateFormat("y-MM-dd").format(date)
                    }).then((value) {
                      currentUser["travellers"] = value;
                      saveState();
                    });
                  },
                  currentTime: traveller["dob"] == null
                      ? DateTime.now()
                      : DateTime.parse(traveller["dob"]),
                  locale: LocaleType.en,
                );
              },
            ),
            SettingsTile(
              title: 'Sex',
              subtitle: traveller["sex"] == "M"
                  ? "Male"
                  : traveller["sex"] == "F"
                      ? "Female"
                      : "Not Set",
              leading: Icon(FontAwesomeIcons.venusMars),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                        callback: saveState,
                        option: "travellerSex",
                        fields: {"traveller": traveller["id"]}),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Address',
              subtitle: traveller["streetAddress"] != null
                  ? traveller["streetAddress"]
                  : "Not Set",
              leading: Icon(Icons.location_on),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      callback: saveState,
                      type: "traveller",
                      option: "travellerAddress",
                      fields: {"traveller": traveller["id"]},
                      formFields: [
                        CustomField(
                          field: "streetAddress",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) =>
                                  t["id"] == traveller["id"])["streetAddress"],
                          labelText: 'Street Address',
                          prefixIcon: FontAwesomeIcons.home,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the street address";
                            }
                            return null;
                          },
                        ),
                        CustomField(
                          field: "city",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) => t["id"] == traveller["id"])["city"],
                          labelText: 'City/Town',
                          prefixIcon: FontAwesomeIcons.city,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the city";
                            }
                            return null;
                          },
                        ),
                        CustomField(
                          field: "region",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) => t["id"] == traveller["id"])["region"],
                          labelText: 'Region',
                          prefixIcon: FontAwesomeIcons.searchLocation,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the region";
                            }
                            return null;
                          },
                        ),
                        CustomField(
                          field: "postcode",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) => t["id"] == traveller["id"])["postcode"],
                          labelText: 'Postcode/ZIP Code',
                          prefixIcon: FontAwesomeIcons.locationArrow,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the postcode";
                            }
                            return null;
                          },
                        ),
                        CustomField(
                          field: "country",
                          type: CustomFieldType.dropdown,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) => t["id"] == traveller["id"])["country"],
                          labelText: "Country",
                          prefixIcon: FontAwesomeIcons.globe,
                          items: suggestions.getCountrySuggestions(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Passport Number',
              subtitle: traveller["passportNumber"] != null
                  ? traveller["passportNumber"]
                  : "Not Set",
              leading: Icon(FontAwesomeIcons.passport),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      callback: saveState,
                      option: "travellerPassportNumber",
                      type: "traveller",
                      fields: {"traveller": traveller["id"]},
                      formFields: [
                        CustomField(
                          field: "passportNumber",
                          type: CustomFieldType.text,
                          initialValue: currentUser["travellers"].firstWhere(
                              (t) =>
                                  t["id"] == traveller["id"])["passportNumber"],
                          labelText: 'Passport Number',
                          prefixIcon: FontAwesomeIcons.passport,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter the passport number";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Delete',
              leading: Icon(
                Icons.remove_circle,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                removeTraveller(traveller["id"]).then((value) {
                  currentUser["travellers"] = value;
                  updateState();
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
}

class SettingsPageChangeForm extends StatefulWidget {
  final String option;
  final Map fields;
  final GlobalKey<FormState> formKey;
  final Function callback;
  final List<CustomField> formFields;
  SettingsPageChangeForm(
      {this.option, this.fields, this.callback, this.formKey, this.formFields});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageChangeFormState(
      option: option,
      fields: fields,
      callback: callback,
      formKey: formKey,
      formFields: formFields,
    );
  }
}

class SettingsPageChangeFormState extends State<SettingsPageChangeForm> {
  String option;
  Map fields;
  Function callback;
  GlobalKey<FormState> formKey;
  List<CustomField> formFields;
  SettingsPageChangeFormState(
      {this.option, this.fields, this.callback, this.formKey, this.formFields});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView.builder(
        itemCount: formFields.length,
        // shrinkWrap: true,
        // scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: formFields[index].type == CustomFieldType.text
                ? CustomTextFormField(
                    initialValue: formFields[index].initialValue,
                    labelText: formFields[index].labelText,
                    prefixIcon: formFields[index].prefixIcon,
                    onSaved: (value) =>
                        callback(formFields[index].field, value),
                    validator: formFields[index].validator,
                  )
                : CustomDropdownButtonFormField(
                    initialValue: formFields[index].initialValue,
                    labelText: formFields[index].labelText,
                    prefixIcon: formFields[index].prefixIcon,
                    onSaved: (value) =>
                        callback(formFields[index].field, value),
                    items: formFields[index].items,
                  ),
          );
        },
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final Function callback;
  final String type;
  final GlobalKey<FormState> formKey;
  final Map formValues;
  final Map fields;
  SaveButton(
      {this.callback, this.type, this.formKey, this.formValues, this.fields});
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          if (type == "traveller") {
            updateTraveller(fields["traveller"], formValues).then((value) {
              currentUser["travellers"] = value;
              callback();
              Navigator.pop(context);
            });
          } else {
            updateUserDetails(formValues).then((value) {
              currentUser = value;
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
