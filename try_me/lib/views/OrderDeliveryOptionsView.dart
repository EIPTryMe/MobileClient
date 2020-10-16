import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/widgets/Loading.dart';

enum deliveryMethodOptions_e { FREE }

class OrderDeliveryOptionsView extends StatefulWidget {
  @override
  _OrderDeliveryOptionsViewState createState() =>
      _OrderDeliveryOptionsViewState();
}

class _OrderDeliveryOptionsViewState extends State<OrderDeliveryOptionsView> {
  double total = 0.0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  PaymentMethod _paymentMethod;
  final _addressController = TextEditingController(text: user.address);
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String _country = '';

  void computeTotal() {
    total = 0.0;
    shoppingCard.forEach((element) {
      total += element.product.pricePerMonth;
    });
  }

  void setError(dynamic error) {
    print(error);
  }

  void addCreditCard() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_qqOqbG3XvLbLfopJ2yWEmrKK00FqSnGPaA",
        merchantId: "Test",
        androidPayMode: 'test'));

    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      setState(() {
        _paymentMethod = paymentMethod;
      });
    }).catchError(setError);
  }

  Future<bool> checkout() async {
    Map result;

    result = await Request.order('eur', _cityController.text, _country,
        _addressController.text, int.parse(_postalCodeController.text));
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: result['clientSecret'],
        paymentMethodId: _paymentMethod.id,
      ),
    ).catchError(setError);
    /*await*/ Request.payOrder(result['order_id']);
    return (true);
  }

  @override
  void initState() {
    super.initState();
    computeTotal();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Widget contactInformation() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: user.firstName,
            decoration: InputDecoration(labelText: 'Prénom'),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nom'),
            initialValue: user.lastName,
            keyboardType: TextInputType.name,
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
            decoration: InputDecoration(labelText: 'Ville'),
            controller: _cityController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Code postal'),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _postalCodeController,
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          CountryCodePicker(
            onInit: (code) {
              _country = code.name;
            },
            onChanged: (code) => setState(() {
              _country = code.name;
            }),
            initialSelection: 'FR',
            favorite: ['FR'],
            showCountryOnly: true,
            showOnlyCountryWhenClosed: true,
            alignLeft: true,
          ),
          TextFormField(
            initialValue: user.phoneNumber,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Numéro de téléphone'),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget deliveryMethod() {
    deliveryMethodOptions_e _options = deliveryMethodOptions_e.FREE;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text("Livraison à domicile GRATUIT"),
          leading: Radio(
            value: deliveryMethodOptions_e.FREE,
            groupValue: _options,
            onChanged: (value) {
              setState(() {
                _options = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget paymentInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _paymentMethod == null
          ? [
              FlatButton(
                child: Text("Ajoutez une carte de crédit"),
                color: Color(0xff58c24c),
                onPressed: () => addCreditCard(),
              ),
            ]
          : [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(_paymentMethod.card.brand.toUpperCase() +
                        ' ***-' +
                        _paymentMethod.card.last4.toString()),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Expire : ' +
                        _paymentMethod.card.expMonth.toString() +
                        '/' +
                        _paymentMethod.card.expYear.toString()),
                  ),
                  Expanded(
                    flex: 3,
                    child: FlatButton(
                      child: Text("Supprimer"),
                      color: Colors.red,
                      onPressed: () => setState(() {
                        _paymentMethod = null;
                      }),
                    ),
                  ),
                ],
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Informations de livraison'),
        centerTitle: true,
        backgroundColor: Color(0xff1F2C47),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 9,
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child:
                      Card(title: "Coordonnées", widget: contactInformation()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      title: "Méthode de livraison", widget: deliveryMethod()),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                  child: Card(
                      title: "Moyen de paiement", widget: paymentInformation()),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              color: Color(0xff58c24c),
              disabledColor: Colors.grey,
              onPressed: _paymentMethod == null
                  ? null
                  : () {
                      if (_formKey.currentState.validate()) {
                        Loading.showLoadingDialog(context);
                        checkout().then((succeed) {
                          if (succeed) {
                            shoppingCard.clear();
                            Navigator.pushNamedAndRemoveUntil(context, 'orderFinished', ModalRoute.withName('home'));
                            print("success");
                          } else
                            print("failed");
                        });
                      }
                    },
              child: Text('Payer ' + '$total€'),
            ),
          ),
        ],
      ),
      key: _scaffoldKey,
    );
  }
}

class Card extends StatelessWidget {
  Card({this.title, this.widget});

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text(title != null ? title : "")),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: widget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
