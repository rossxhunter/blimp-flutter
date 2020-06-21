import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recase/recase.dart';
import 'package:settings_ui/settings_ui.dart';

List<Map> travellers = [
  {
    "fullName": "Ross Hunter",
    "DOB": "21/02/98",
    "sex": "M",
    "address": {"streetAddress": "13 Spring Way"},
    "passportNumber": "79728862"
  },
  {
    "fullName": "Alice Elizabeth Miller",
    "DOB": "26/08/98",
    "sex": "F",
    "address": {"streetAddress": "162 Wentworth Road"},
    "passportNumber": "82952712"
  }
];

class SettingsPage extends StatelessWidget {
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
          backgroundColor: CustomColors.greyBackground,
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
    sections.add(SettingsSection(title: 'Booking', tiles: [
      SettingsTile(
        title: 'Payment Cards',
        subtitle: '2 Cards',
        leading: Icon(Icons.credit_card),
        onTap: () {},
      ),
      SettingsTile(
        title: 'Travellers',
        subtitle: '1 Traveller',
        leading: Icon(Icons.people),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPageChange(
                option: "travellers",
              ),
            ),
          );
        },
      ),
    ]));
    sections.add(
      SettingsSection(
        title: 'Explore',
        tiles: [
          SettingsTile(
            title: 'Home City',
            subtitle: 'London',
            leading: Icon(Icons.location_city),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Max Budget',
            subtitle: '£3000',
            leading: Icon(Icons.attach_money),
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
            leading: Icon(Icons.language),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(FontAwesomeIcons.language),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Currency',
            subtitle: 'GBP',
            leading: Icon(FontAwesomeIcons.moneyBill),
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
            leading: Icon(Icons.info),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Help',
            // subtitle: 'English',
            leading: Icon(Icons.help),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Contact',
            // subtitle: 'GBP',
            leading: Icon(Icons.email),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Feedback',
            // subtitle: 'GBP',
            leading: Icon(Icons.feedback),
            onTap: () {},
          ),
        ],
      ),
    );
    sections.add(
      SettingsSection(
        title: '',
        tiles: [
          SettingsTile(
            title: 'Logout',
            leading: Icon(Icons.exit_to_app),
            onTap: () {},
          ),
        ],
      ),
    );
    return sections;
  }
}

class SettingsPageChange extends StatefulWidget {
  final String option;
  SettingsPageChange({this.option});
  @override
  State<StatefulWidget> createState() {
    return SettingsPageChangeState(option: option);
  }
}

class SettingsPageChangeState extends State<SettingsPageChange> {
  final String option;
  SettingsPageChangeState({this.option});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ReCase(option).sentenceCase,
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
          child: _getSettingsPageChangeBody(context),
        ),
      ),
    );
  }

  List<Widget> _getActions() {
    if (option == "travellers") {
      return [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: AnimatedButton(
            callback: () {
              setState(() {
                travellers.add({
                  "fullName": "",
                  "DOB": "",
                  "sex": "",
                  "address": {
                    "streetAddress": "",
                  },
                  "passportNumber": ""
                });
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

  List<SettingsSection> _getTravellersSections(
      List<Map> trave, BuildContext context) {
    List<SettingsSection> sections = [];
    int i = 0;
    for (Map t in travellers) {
      i += 1;
      sections.add(
        SettingsSection(
          title: 'Traveller ' + i.toString(),
          tiles: [
            SettingsTile(
              title: 'Full Name',
              subtitle: t["fullName"] != "" ? t["fullName"] : "Not Set",
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Date of Birth',
              subtitle: t["DOB"] != "" ? t["DOB"] : "Not Set",
              leading: Icon(FontAwesomeIcons.calendar),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Sex',
              subtitle: t["sex"] == "M"
                  ? "Male"
                  : t["sex"] == "F" ? "Female" : "Not Set",
              leading: Icon(FontAwesomeIcons.venusMars),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Address',
              subtitle: t["address"]["streetAddress"] != ""
                  ? t["address"]["streetAddress"]
                  : "Not Set",
              leading: Icon(Icons.location_on),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageChange(
                      option: "address",
                    ),
                  ),
                );
              },
            ),
            SettingsTile(
              title: 'Passport Number',
              subtitle:
                  t["passportNumber"] != "" ? t["passportNumber"] : "Not Set",
              leading: Icon(FontAwesomeIcons.passport),
              onTap: () {},
            ),
            SettingsTile(
              title: 'Delete',
              leading: Icon(
                Icons.remove_circle,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                setState(() {
                  travellers.removeAt(i - 1);
                });
              },
            ),
          ],
        ),
      );
    }
    return sections;
  }

  Widget _getSettingsPageChangeBody(BuildContext context) {
    if (option == "travellers") {
      List<Map> travellers = [
        {
          "fullName": "Ross Hunter",
          "DOB": "21/02/98",
          "sex": "M",
          "address": {"streetAddress": "13 Spring Way"},
          "passportNumber": "79728862"
        },
        {
          "fullName": "Alice Elizabeth Miller",
          "DOB": "26/08/98",
          "sex": "F",
          "address": {"streetAddress": "162 Wentworth Road"},
          "passportNumber": "82952712"
        }
      ];
      return SettingsList(
        sections: _getTravellersSections(travellers, context),
      );
    } else if (option == "address") {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: Icon(FontAwesomeIcons.home),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.lightGrey,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'City/Town',
                    prefixIcon: Icon(Icons.location_city),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGrey,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'State/Province/County/Region',
                    prefixIcon: Icon(FontAwesomeIcons.searchLocation),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGrey,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Postcode/ZIP Code',
                    prefixIcon: Icon(FontAwesomeIcons.locationArrow),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGrey,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Country',
                    prefixIcon: Icon(Icons.language),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGrey,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
