import 'package:flutter/material.dart';

import 'package:tryme/Dialogs.dart';
import 'package:tryme/Globals.dart';

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

class DrawerNotConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 70.0,
          child: DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff1F2C47),
            ),
          ),
        ),
        ListTile(
          title: Text('Authentification'),
          onTap: () => Navigator.pushNamed(context, 'authentification'),
        ),
      ],
    ));
  }
}

class DrawerIsConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff1F2C47), Color(0xff1f2c76)]),
          ),
          accountName: Text(
            user.firstName != null ? user.firstName : 'Pas de prénom défini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          accountEmail:
              Text(user.email != null ? user.email : "Pas d'email défini"),
          currentAccountPicture: CircleAvatar(
            backgroundImage: user.pathToAvatar != null
                ? NetworkImage(user.pathToAvatar)
                : AssetImage("assets/company_logo_temp.jpg"),
          ),
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text(
            'Mes Commandes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'userOrders/Mes Commandes'),
              child: Text(
                'Tout voir',
                style: TextStyle(
                  color: Color(0xff3e97b7),
                  fontSize: 12.0,
                ),
              )),
        ),
        Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Non payées',
              ),
              onTap: () =>
                  Navigator.pushNamed(context, 'userOrders/Non payées'),
            ),
            ListTile(
              title: Text(
                'Payées',
              ),
              onTap: () => Navigator.pushNamed(context, 'userOrders/Payées'),
            ),
            ListTile(
              title: Text(
                'En attente',
              ),
              onTap: () =>
                  Navigator.pushNamed(context, 'userOrders/En attente'),
            ),
            ListTile(
              title: Text(
                'Expédiées',
              ),
              onTap: () => Navigator.pushNamed(context, 'userOrders/Expédiées'),
            ),
            ListTile(
              title: Text(
                'Livrées',
              ),
              onTap: () => Navigator.pushNamed(context, 'userOrders/Livrées'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Divider(
            height: 1,
            color: Colors.grey[800],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Divider(
            height: 1,
            color: Colors.grey[800],
          ),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(
            'Informations personnelles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => Navigator.pushNamed(context, 'personalInformation'),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Divider(
            height: 1,
            color: Colors.grey[800],
          ),
        ),
        ListTile(
          title: Text(
            'Déconnexion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            final bool _logout = await LogOut().confirm(context);
            if (_logout != null) {
              disconnect(_logout, context);
            }
          },
        ),
      ],
    ));
  }
}
