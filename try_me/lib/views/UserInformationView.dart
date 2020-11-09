import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/tools/Validator.dart';

class UserInformationView extends StatefulWidget {
  @override
  _UserInformationViewState createState() => _UserInformationViewState();
}

class _UserInformationViewState extends State<UserInformationView> {
  TextEditingController _firstNameController;
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _emailController;
  FocusNode _firstNameFocusNode;
  FocusNode _nameFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _emailFocusNode;
  DateTime _currentBirthday;
  String _currentAddress;
  double _inputHeight = 70.0;
  Color _iconColor1 = Color(0xFF1E2439);
  Color _iconColor2 = Color(0xFF39FEBF);
  Color _iconColor3 = Styles.colors.main;
  int _ordersNumber = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _firstNameController = TextEditingController(text: user.firstName);
    _nameController = TextEditingController(text: user.lastName);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);

    _firstNameFocusNode = FocusNode();
    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus)
        saveFirstName(_firstNameController.text.trim());
    });
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) saveName(_nameController.text.trim());
    });
    _phoneFocusNode = FocusNode();
    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) savePhone(_phoneController.text.trim());
    });
    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) saveEmail(_emailController.text.trim());
    });

    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) {
        _firstNameFocusNode.unfocus();
        _nameFocusNode.unfocus();
        _phoneFocusNode.unfocus();
        _emailFocusNode.unfocus();
      }
    });

    if (user.birthDate != null)
      _currentBirthday = DateTime.parse(user.birthDate);
    _currentAddress = user.address;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    _firstNameFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void getData() async {
    Request.getOrdersNumber().then((ordersNumber) {
      setState(() {
        _ordersNumber = ordersNumber;
      });
    });
  }

  void showSnackBarMessage(String str) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          str,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void saveFirstName(String str) {
    if (str == user.firstName) return;
    if (Validator.nameValidator(str) != null) return;
    Request.modifyUserFirstName(str).then((hasException) {
      setState(() {
        user.firstName = hasException ? user.firstName : str;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Prénom sauvegardé');
    });
  }

  void saveName(String str) {
    if (str == user.lastName) return;
    if (Validator.nameValidator(str) != null) return;
    Request.modifyUserName(str).then((hasException) {
      setState(() {
        user.lastName = hasException ? user.lastName : str;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Nom sauvegardé');
    });
  }

  void savePhone(String str) {
    if (str == user.phone) return;
    if (Validator.phoneValidator(str) != null) return;
    Request.modifyUserPhone(str).then((hasException) {
      setState(() {
        user.phone = hasException ? user.phone : str;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Téléphone sauvegardé');
    });
  }

  void saveEmail(String str) {
    if (Validator.emailValidator(str) != null) return;
    if (str == user.email) return;
    Request.modifyUserEmail(str).then((hasException) {
      setState(() {
        user.email = hasException ? user.email : str;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Email sauvegardé');
    });
  }

  void saveBirthday(String str) {
    if (str == user.birthDate) return;
    Request.modifyUserBirthday(str).then((hasException) {
      setState(() {
        user.birthDate = hasException ? user.birthDate : str;
      });
      showSnackBarMessage(
          hasException ? 'Erreur' : 'Date de naissance sauvegardée');
    });
  }

  void saveAddress(String str) {
    if (str == user.address) return;
    Request.modifyUserAddress(str).then((hasException) {
      setState(() {
        user.address = hasException ? user.address : str;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Adresse sauvegardée');
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () => disconnect(context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Déconnexion"),
      content: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getAddress(String address) async {
    bool error = false;
    List<Address> addresses =
        await Geocoder.local.findAddressesFromQuery(address).catchError((_) {
      error = true;
    });
    Address first;

    if (error == false) first = addresses.first;
    LocationResult locationResult = await showLocationPicker(
      context,
      'AIzaSyBOfQxDPTnCGCVw-OMy4yt4Iy9LgMCKbcQ',
      automaticallyAnimateToCurrentLocation: error == true ? true : false,
      initialCenter: error == true
          ? LatLng(48.8589507, 2.2770205) // Paris
          : LatLng(first.coordinates.latitude, first.coordinates.longitude),
      myLocationButtonEnabled: true,
      desiredAccuracy: LocationAccuracy.best,
    );
    return (locationResult.address);
  }

  void disconnect(BuildContext context) {
    isLoggedIn = false;
    shoppingCard.clear();
    auth0User = Auth0User();
    user = User();
    Navigator.pushNamedAndRemoveUntil(context, 'app', ModalRoute.withName('/'));
  }

  Widget _divider({height: 1.0}) {
    return Divider(
      height: height,
      color: Styles.colors.divider,
    );
  }

  Widget _topInfoCard() {
    const double imageBoxSize = 90.0;
    String firstName = user.firstName != null ? user.firstName : '';
    String lastName = user.lastName != null ? user.lastName : '';
    String phone = user.phone != null ? user.phone : '';
    String email = user.email != null ? user.email : '';

    return Column(
      children: [
        _divider(),
        Container(
          height: imageBoxSize,
          color: Styles.colors.lightBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: imageBoxSize,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Padding(
                    padding: const EdgeInsets.all(imageBoxSize * 0.3 / 2.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.picture),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName + ' ' + lastName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        phone,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Styles.colors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15.0, top: 15.0, bottom: 15.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Styles.colors.background,
                    onPressed: () => showAlertDialog(context),
                    child: Text(
                      'Déconnexion',
                      style: TextStyle(color: Styles.colors.text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _input({IconData icon, Color iconBackground, Widget widget}) {
    return SizedBox(
      height: _inputHeight,
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          if (widget != null)
            Expanded(
              child: widget,
            ),
        ],
      ),
    );
  }

  Widget _myOrders() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      color: Styles.colors.lightBackground,
      child: _input(
        icon: Icons.favorite,
        iconBackground: _iconColor3,
        widget: FlatButton(
          padding: const EdgeInsets.all(0.0),
          height: _inputHeight,
          onPressed: () => Navigator.pushNamed(context, 'orders/'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes commandes',
                style: TextStyle(
                  color: Styles.colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 17,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Styles.colors.main,
                      borderRadius: BorderRadius.all(Radius.circular(32.5)),
                    ),
                    child: Center(
                      child: Text(
                        _ordersNumber.toString(),
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFFBEC7C5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactInfo() {
    bool lock = false;

    return Container(
      color: Styles.colors.lightBackground,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          _input(
            icon: Icons.person,
            iconBackground: _iconColor1,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _firstNameFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Prénom',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _firstNameController,
              validator: (value) => Validator.nameValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.people_alt,
            iconBackground: _iconColor2,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _nameFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Nom',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _nameController,
              validator: (value) => Validator.nameValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.phone,
            iconBackground: _iconColor3,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _phoneFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Téléphone',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _phoneController,
              validator: (value) => Validator.phoneValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.email,
            iconBackground: _iconColor1,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _emailFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Mail',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40),
              ],
              controller: _emailController,
              validator: (value) => Validator.emailValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.cake,
            iconBackground: _iconColor2,
            widget: GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(DateTime.now().year - 100),
                  maxTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _currentBirthday = date);
                    saveBirthday(
                        '${date.year}-${NumberFormatTool.formatDate(month: date.month)}-${NumberFormatTool.formatDate(day: date.day)}');
                  },
                  currentTime: DateTime.parse(user.birthDate),
                );
              },
              child: Container(
                color: Colors.transparent,
                height: _inputHeight,
                alignment: Alignment.centerLeft,
                child: _currentBirthday != null
                    ? Text(
                        '${NumberFormatTool.formatDate(day: _currentBirthday.day)}/${NumberFormatTool.formatDate(month: _currentBirthday.month)}/${_currentBirthday.year}',
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Date de naissance',
                        style: TextStyle(
                          color: Styles.colors.textPlaceholder,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.location_on,
            iconBackground: _iconColor3,
            widget: GestureDetector(
              onTap: () {
                if (!lock) {
                  lock = true;
                  getAddress(user.address).then((address) {
                    lock = false;
                    setState(() => _currentAddress = address);
                    saveAddress(address);
                  }).catchError((_) {
                    lock = false;
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
                height: _inputHeight,
                alignment: Alignment.centerLeft,
                child: _currentAddress != null
                    ? Text(
                        _currentAddress,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Adresse',
                        style: TextStyle(
                          color: Styles.colors.textPlaceholder,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _topInfoCard(),
        SizedBox(height: 15),
        _myOrders(),
        SizedBox(height: 15),
        _contactInfo(),
      ],
    );
  }
}
