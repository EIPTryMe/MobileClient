import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final _firstNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  double _widthScreen;
  double _heightScreen;

  void disconnect(bool _yes, BuildContext context) {
    if (_yes) {
      isLoggedIn = false;
      shoppingCard.clear();
      auth0User = Auth0User();
      user = User();
      Navigator.pushNamedAndRemoveUntil(
          context, 'home', ModalRoute.withName('/'));
    }
  }

  void save() {
    if (_formKey.currentState.validate()) {
      User userSave = User(
          firstName: _firstNameController.text,
          lastName: _nameController.text,
          address: _addressController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          birthDate: _birthDateController.text);
      Request.modifyUser(userSave).then((value) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Informations sauvegardées',
            textAlign: TextAlign.center,
          ),
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstNameController.text = user.firstName;
      _nameController.text = user.lastName;
      _addressController.text = user.address;
      _phoneController.text = user.phoneNumber;
      _emailController.text = user.email;
      _birthDateController.text = user.birthDate;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Widget _presentation(double widthScreen) {
    return Container(
      color: Colors.white,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Photo"),
            CircleAvatar(
              backgroundImage: user.pathToAvatar != null
                  ? NetworkImage(user.pathToAvatar)
                  : AssetImage("assets/company_logo_temp.jpg"),
              radius: widthScreen / 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget widget) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget,
      ),
    );
  }

  Widget _info() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Prénom'),
            keyboardType: TextInputType.name,
            controller: _firstNameController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nom'),
            keyboardType: TextInputType.name,
            controller: _nameController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Adresse'),
            keyboardType: TextInputType.streetAddress,
            controller: _addressController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Téléphone'),
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Date de naissance'),
            keyboardType: TextInputType.datetime,
            controller: _birthDateController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    _heightScreen = (_height > _width) ? _height : _width;
    _widthScreen = (_height > _width) ? _width : _height;
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          children: [
            Container(
              height: 60.0,
              child: FlatButton(
                onPressed: () => disconnect(true, context),
                child:
                    Text("Déconnexion", style: TextStyle(color: Colors.white)),
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),
            _presentation(_widthScreen),
            SizedBox(height: 12),
            _card(_info()),
            SizedBox(height: 12),
            Container(
              height: 60.0,
              child: FlatButton(
                onPressed: () => save(),
                child:
                    Text("Sauvegarder", style: TextStyle(color: Colors.white)),
                color: Color(0xff58c24c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  var edit = new List(7);
  double _widthScreen;
  double _heightScreen;
  bool _infoValid;
  final _formKey = GlobalKey<FormState>();
  String birthDateDisplay;

  String buttonText = 'Sauvegarder';
  String tmp;

  @override
  void initState() {
    initBool(edit);
    birthDateDisplay = modifyBirthDateDisplay(user.birthDate);
    super.initState();
  }

  void initBool(var list) {
    for (int i = 0; i < 7; i++) {
      list[i] = false;
    }
  }

  String timeStamp(String userBirthdate) {
    String tmp = "";
    if (userBirthdate != null) {
      var parts = userBirthdate.split("/");
      tmp += parts[2] + '-' + parts[1] + '-' + parts[0];
    }
    return (tmp);
  }

  String modifyBirthDateDisplay(String userBirthdate) {
    String tmp = "";
    if (userBirthdate != null) {
      var parts = userBirthdate.split("-");
      tmp += parts[2] + '/' + parts[1] + '/' + parts[0];
    }
    return (tmp);
  }

  Widget _presentation(double widthScreen) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(widthScreen / 20),
          child: CircleAvatar(
            backgroundImage: user.pathToAvatar != null
                ? NetworkImage(user.pathToAvatar)
                : AssetImage("assets/company_logo_temp.jpg"),
            radius: widthScreen / 10,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    //get first name here
                    child: (() {
                  if (user.firstName != null && user.firstName != "")
                    return (Text(
                      user.firstName,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.black,
                      ),
                    ));
                  else
                    return (Text(
                      "Pas de prénom défini",
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.orange,
                      ),
                    ));
                }())),
                SizedBox(height: 10.0),
                Container(
                    //get last name here
                    child: (() {
                  if (user.lastName != null && user.lastName != "")
                    return (Text(
                      user.lastName,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.black,
                      ),
                    ));
                  else
                    return (Text(
                      "Pas de nom de famille défini",
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.orange,
                      ),
                    ));
                }())),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _personalFirstName(var edit) {
    if (edit[1]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue:
                            user.firstName != null ? user.firstName : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entrer votre prénom",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          _infoValid =
                              RegExp(r"^[a-zA-Z-]{2,16}$").hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Le format de votre prénom est incorrect";
                          }
                          tmp = value;
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[1] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    user.firstName = tmp;
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.firstName != null && user.firstName != "")
                return (Text(
                  user.firstName,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas de prénom défini",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[1] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _personalLastName(var edit) {
    if (edit[2]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue:
                            user.lastName != null ? user.lastName : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entrer votre nom de famille",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          _infoValid =
                              RegExp(r"^[a-zA-Z-' ]{2,20}$").hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Le format de votre nom de famille est incorrect";
                          }
                          tmp = value;
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[2] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    user.lastName = tmp;
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.lastName != null && user.lastName != "")
                return (Text(
                  user.lastName,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas de nom de famille défini",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[2] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _personalAddress(var edit) {
    if (edit[3]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue: user.address != null ? user.address : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entrer votre adresse",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          _infoValid = RegExp(r"^[a-zA-Z0-9-', ]{2,100}$")
                              .hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Le format de votre adresse est incorrect";
                          }
                          tmp = value;
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[3] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    user.address = tmp;
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.address != null && user.address != "")
                return (Text(
                  user.address,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas d'adresse définie",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[3] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _personalPhoneNumber(var edit) {
    if (edit[4]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue:
                            user.phoneNumber != null ? user.phoneNumber : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entrer votre numéro de téléphone",
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          _infoValid =
                              RegExp(r"^[0-9 ]{10,10}$").hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Le format de votre numéro de téléphone est incorrect";
                          }
                          tmp = value;
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[4] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    //tmp = modifyPhoneNumber(tmp);
                    user.phoneNumber = tmp;
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.phoneNumber != null && user.phoneNumber != "")
                return (Text(
                  user.phoneNumber,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas de numéro de téléphone défini",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[4] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _personalEmail(var edit) {
    if (edit[5]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue: user.email != null ? user.email : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entre votre email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          _infoValid = RegExp(
                                  r"^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$")
                              .hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Le format de votre email est incorrect";
                          }
                          tmp = value;
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[5] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    user.email = tmp;
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.email != null && user.email != "")
                return (Text(
                  user.email,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas d'adresse mail définie",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[5] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _personalBirthDate(var edit) {
    if (edit[6]) {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Color(0xfff99e38),
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue:
                            user.birthDate != null ? birthDateDisplay : "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: "Entrer votre date de naissance",
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          _infoValid = RegExp(
                                  r"^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$")
                              .hasMatch(value);
                          if (value.isEmpty) {
                            tmp = null;
                            return null;
                          } else if (!_infoValid) {
                            return "Votre date de naissance est incorrect format attendu dd/mm/yyyy";
                          }
                          tmp = value;
                          setState(() {
                            birthDateDisplay = value;
                          });
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    edit[6] = false;
                    edit[0] = false;
                    buttonText = 'Sauvegarder';
                    user.birthDate = timeStamp(tmp);
                  }
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: (() {
              if (user.birthDate != null && user.birthDate != "")
                return (Text(
                  user.birthDate,
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ));
              else
                return (Text(
                  "Pas de date de naisance définie",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.orange,
                  ),
                ));
            }())),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    edit[6] = true;
                    edit[0] = true;
                    buttonText = '';
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _myDivider() {
    return Container(
      margin:
          EdgeInsets.only(left: _widthScreen / 10, right: _widthScreen / 10),
      child: Divider(
        height: 1,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    _heightScreen = (_height > _width) ? _height : _width;
    _widthScreen = (_height > _width) ? _width : _height;

    return SingleChildScrollView(
      child: Container(
        height: _heightScreen * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _presentation(_widthScreen),
            _myDivider(),
            _personalFirstName(edit),
            _myDivider(),
            _personalLastName(edit),
            _myDivider(),
            _personalAddress(edit),
            _myDivider(),
            _personalPhoneNumber(edit),
            _myDivider(),
            _personalEmail(edit),
            _myDivider(),
            _personalBirthDate(edit),
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (!edit[0]) {
                    Request.modifyUser().whenComplete(() {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Informations sauvegardées',
                          textAlign: TextAlign.center,
                        ),
                      ));
                    });
                  }
                });
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Color(0xff58c24c),
            ),
          ],
        ),
      ),
    );
  }
}
*/
