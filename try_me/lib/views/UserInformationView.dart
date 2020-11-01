import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';

class UserInformationView extends StatefulWidget {
  @override
  _UserInformationViewState createState() => _UserInformationViewState();
}

class _UserInformationViewState extends State<UserInformationView> {
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
