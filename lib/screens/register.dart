import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nutriclock_app/constants/constants.dart';
import 'package:nutriclock_app/models/AcceptanceTerms.dart';
import 'package:nutriclock_app/models/Disease.dart';
import 'package:nutriclock_app/models/Drug.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:nutriclock_app/models/Usf.dart';
import 'package:nutriclock_app/network_utils/api.dart';
import 'package:nutriclock_app/screens/home.dart';
import 'package:nutriclock_app/utils/AppWidget.dart';
import 'package:nutriclock_app/utils/DropMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  AcceptanceTerms terms;
  var name;
  var email;
  var password;
  var gender;
  var weight;
  var height;
  var usfId;
  var confirmationPassword;
  var _image;
  var diseaseToAdd;
  var selectedDisease;
  var selectedAlergy;
  var drugNameToAdd;
  var drugPosologyToAdd;
  var drugTimeToAdd;
  var drugTypeToAdd;
  var _all = false;
  var _monday = false;
  var _tuesday = false;
  var _wednesday = false;
  var _thursday = false;
  var _friday = false;
  var _saturday = false;
  var _sunday = false;
  var _obscuredPassword = true;
  var _obscuredConfirmationPassword = true;
  List<String> diseases = [];
  List<Drug> drugs = [];
  List<String> diseasesOptions = [];
  List<String> allergiesOptions = [];
  List<Usf> usfs = [];
  List<DropMenu> gendersList = [
    DropMenu('MALE', 'Masculino'),
    DropMenu('FEMALE', 'Feminino'),
    DropMenu('NONE', 'Não me identifico')
  ];
  final ptDatesFuture = initializeDateFormatting('pt', null);
  DateTime selectedDate = DateTime.now();
  final dateFormat = new DateFormat('dd/MM/yyyy');
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var appWidget = AppWidget();

  @override
  void initState() {
    _loadDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: appWidget.getImageContainer(
        "assets/images/bg_green.png",
        _isLoading,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 40.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRect(
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        height: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          _showPicker(context);
                                        },
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundColor: Color(0xFFd7d7d7),
                                          child: _image != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.file(
                                                    _image,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFd7d7d7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  width: 100,
                                                  height: 100,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        labelText: 'Nome',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (nameValue) {
                                        if (nameValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }
                                        name = nameValue;
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        DropdownButton(
                                          value: usfId,
                                          hint: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Text(
                                              "Instituição",
                                              style: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Color(0xFFA3E1CB)),
                                          onChanged: (newValue) {
                                            setState(() {
                                              usfId = newValue;
                                            });
                                          },
                                          isExpanded: true,
                                          items: usfs
                                              .map<DropdownMenuItem<int>>(
                                                  (Usf value) {
                                            return DropdownMenuItem<int>(
                                              value: value.id,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Text(value.name),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Icon(
                                              Icons.home_work_sharp,
                                              color: Color(0xFFA3E1CB),
                                            )),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        DropdownButton(
                                          value: gender,
                                          hint: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Text(
                                              "Sexo",
                                              style: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Color(0xFFA3E1CB)),
                                          onChanged: (newValue) {
                                            setState(() {
                                              gender = newValue;
                                            });
                                          },
                                          isExpanded: true,
                                          items: gendersList
                                              .map<DropdownMenuItem<String>>(
                                                  (DropMenu item) {
                                            return DropdownMenuItem<String>(
                                              value: item.value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Text(item.description),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Icon(
                                              Icons.wc,
                                              color: Color(0xFFA3E1CB),
                                            )),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Text(
                                                  'Data de Nascimento',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => _selectDate(context),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 35.0),
                                            child: Text(
                                              dateFormat.format(selectedDate),
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.accessibility,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        suffix: Text(
                                          'kg',
                                          style: TextStyle(
                                              color: Color(0xFF000000)),
                                        ),
                                        labelText: 'Peso',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (weightValue) {
                                        if (weightValue.isNotEmpty &&
                                            double.tryParse(weightValue) ==
                                                null) {
                                          return ERROR_INVALID_FORMAT_FIELD;
                                        }

                                        if (weightValue.isNotEmpty &&
                                            double.tryParse(weightValue) <= 0) {
                                          return ERROR_NEGATIVE_VALUE;
                                        }
                                        weight = weightValue;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.swap_vert,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        suffix: Text(
                                          'cm',
                                          style: TextStyle(
                                              color: Color(0xFF000000)),
                                        ),
                                        labelText: 'Altura',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (heightValue) {
                                        if (heightValue.isNotEmpty &&
                                            double.tryParse(heightValue) ==
                                                null) {
                                          return ERROR_INVALID_FORMAT_FIELD;
                                        }

                                        if (heightValue.isNotEmpty &&
                                            double.tryParse(heightValue) <= 0) {
                                          return ERROR_NEGATIVE_VALUE;
                                        }

                                        height = heightValue;
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        labelText: 'Email',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (emailValue) {
                                        if (emailValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(emailValue)) {
                                          return ERROR_INVALID_FORMAT_FIELD;
                                        }
                                        email = emailValue;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      obscureText: _obscuredPassword,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: _togglePassword,
                                          child: Icon(
                                            _obscuredPassword
                                                ? Icons.remove_red_eye
                                                : Icons.remove_red_eye_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFA3E1CB),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        labelText: 'Password',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      validator: (passwordValue) {
                                        if (passwordValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }
                                        password = passwordValue;
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                      cursorColor: Color(0xFF9b9b9b),
                                      keyboardType: TextInputType.text,
                                      obscureText:
                                          _obscuredConfirmationPassword,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: _toggleConfirmationPassword,
                                          child: Icon(
                                            _obscuredConfirmationPassword
                                                ? Icons.remove_red_eye
                                                : Icons.remove_red_eye_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFA3E1CB)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Color(0xFFA3E1CB),
                                        ),
                                        labelText: 'Confirmação de password',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(
                                            color: Color(0xFF9b9b9b),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (passwordValue) {
                                        if (passwordValue.isEmpty) {
                                          return ERROR_MANDATORY_FIELD;
                                        }

                                        if (passwordValue.isNotEmpty &&
                                            passwordValue != password) {
                                          return ERROR_CONFIRMATION_PASS_MUST_BE_EQUAL;
                                        }
                                        confirmationPassword = passwordValue;
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.healing,
                                            color: Color(0xFFA3E1CB),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Problemas de Saúde',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: TextButton(
                                              onPressed: () =>
                                                  {_showAddDiseaseModal()},
                                              child: Icon(
                                                Icons.add_circle,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ..._getDiseases(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.receipt,
                                            color: Color(0xFFA3E1CB),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Medicamentos / Suplementos Habituais',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: TextButton(
                                              onPressed: () =>
                                                  {_showAddDrugModal()},
                                              child: Icon(
                                                Icons.add_circle,
                                                color: Color(0xFFA3E1CB),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ..._getDrugs(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _showAcceptanceTermsModal();
                                            } else {
                                              appWidget.showSnackbar(
                                                  "Corrija os erros no formulário!",
                                                  Colors.red,
                                                  _scaffoldKey);
                                            }
                                          },
                                          child: Text(
                                            _isLoading
                                                ? 'Aguarde...'
                                                : 'Registar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Color(0xFFA3E1CB),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDrugModal() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          var contentText = "";

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  "Adicionar Medicamento / Suplemento",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA3E1CB),
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        "Esta informação poderá posteriormente ser confirmada com o seu médico",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        contentText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                      DropdownButton(
                        value: drugTypeToAdd,
                        hint: Text(
                          "Tipo",
                          style: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) {
                          setState(() {
                            drugTypeToAdd = newValue;
                          });
                        },
                        isExpanded: true,
                        items: [
                          DropMenu('M', 'Medicamento'),
                          DropMenu('S', 'Suplemento'),
                        ].map<DropdownMenuItem<String>>((DropMenu item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: Text(item.description),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          this.setState(() {
                            drugNameToAdd = value;
                          }),
                        },
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                          ),
                          hintText: "Nome",
                          hintStyle: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          this.setState(() {
                            drugPosologyToAdd = value;
                          }),
                        },
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                          ),
                          suffix: Text('mg/ml'),
                          hintText: "Dosagem",
                          hintStyle: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      DropdownButton(
                        value: drugTimeToAdd,
                        hint: Text("Intervalo Horário"),
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) {
                          setState(() {
                            drugTimeToAdd = newValue;
                          });
                        },
                        isExpanded: true,
                        items: [
                          "De 4 em 4h",
                          "De 6 em 6h",
                          "De 8 em 8h",
                          "De 12 em 12h",
                          "De 24 em 24h",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Selecione o dia de toma:',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _all,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _all = newValue;
                                  });
                                },
                              ),
                              Text(
                                'Todos os dias',
                              ),
                            ],
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 40.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _monday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _monday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      '2ª',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _tuesday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _tuesday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      '3ª',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _wednesday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _wednesday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      '4ª',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _thursday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _thursday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      '5ª',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 40.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _friday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _friday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      '6ª',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _saturday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _saturday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Sáb.',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _sunday,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          _sunday = newValue;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Dom.',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Adicionar',
                      style: TextStyle(color: Color(0xFF60B2A3)),
                    ),
                    onPressed: () {
                      setState(() {
                        contentText = "";
                      });

                      if (drugNameToAdd == null ||
                          drugNameToAdd.trim() == "" ||
                          drugPosologyToAdd == null ||
                          drugPosologyToAdd.trim() == "") {

                        setState(() {
                          contentText = "Deve preencher o nome e dosagem";
                        });
                        return;
                      }
                      var days = "";

                      if (_all)
                        days = "1,2,3,4,5,6,7,";
                      else {
                        if (_sunday) days += "1,";
                        if (_monday) days += "2,";
                        if (_tuesday) days += "3,";
                        if (_wednesday) days += "4,";
                        if (_thursday) days += "5,";
                        if (_friday) days += "6,";
                        if (_saturday) days += "7,";
                      }

                      var drugToAdd = Drug(drugNameToAdd, drugPosologyToAdd,
                          drugTimeToAdd, days, drugTypeToAdd);

                      var auxDrugsList = drugs;

                      auxDrugsList.add(drugToAdd);

                      this.setState(() {
                        drugs = auxDrugsList;
                        _all = false;
                        _saturday = false;
                        _sunday = false;
                        _monday = false;
                        _tuesday = false;
                        _wednesday = false;
                        _thursday = false;
                        _friday = false;
                        drugNameToAdd = null;
                        drugPosologyToAdd = null;
                        drugTimeToAdd = null;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Future<void> _showAddDiseaseModal() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              'Adicionar Problema de Saúde',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3E1CB)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Esta informação poderá posteriormente ser confirmada com o seu médico",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  DropdownButton(
                    value: selectedDisease,
                    hint: Text("Seleciona a doença"),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDisease = newValue;
                      });
                    },
                    isExpanded: true,
                    items: diseasesOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    value: selectedAlergy,
                    hint: Text("Seleciona a alergia"),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        selectedAlergy = newValue;
                      });
                    },
                    isExpanded: true,
                    items: allergiesOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    onChanged: (value) => {
                      this.setState(() {
                        diseaseToAdd = value;
                      }),
                    },
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA3E1CB)),
                      ),
                      hintText: "Outra doença",
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Adicionar',
                  style: TextStyle(color: Color(0xFF60B2A3)),
                ),
                onPressed: () {
                  _addDisease();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  _addDisease() {
    var auxDiseases = diseases;
    if (diseaseToAdd != null && diseaseToAdd.trim() != '') {
      if (!auxDiseases.contains(diseaseToAdd)) auxDiseases.add(diseaseToAdd);
    }

    if (selectedDisease != null) {
      if (!auxDiseases.contains(selectedDisease))
        auxDiseases.add(selectedDisease);
    }

    if (selectedAlergy != null) {
      if (!auxDiseases.contains(selectedAlergy))
        auxDiseases.add(selectedAlergy);
    }

    this.setState(() {
      diseases = auxDiseases;
      diseaseToAdd = null;
      selectedDisease = null;
      selectedAlergy = null;
    });
  }

  List<Widget> _getDiseases() {
    List<Widget> diseasesText = [];
    for (int i = 0; i < diseases.length; i++) {
      diseasesText.add(Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              diseases[i],
              style: TextStyle(
                color: Colors.grey,
              ),
            )),
            SizedBox(width: 16),
            SizedBox(
              width: 40,
              child: TextButton(
                onPressed: () => {_removeDisease(i)},
                child: Icon(Icons.delete, color: Colors.grey),
              ),
            )
          ],
        ),
      ));
    }
    return diseasesText;
  }

  void _removeDisease(int i) {
    var auxDiseases = diseases;
    auxDiseases.removeAt(i);
    this.setState(() {
      diseases = auxDiseases;
    });
  }

  void _removeDrug(int i) {
    var auxDrugs = drugs;
    auxDrugs.removeAt(i);
    this.setState(() {
      drugs = auxDrugs;
    });
  }

  List<Widget> _getDrugs() {
    List<Widget> drugsWidgets = [];

    for (int i = 0; i < drugs.length; i++) {
      drugsWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "${drugs[i].name} ${drugs[i].posology} mg/ml",
              style: TextStyle(
                color: Colors.grey,
              ),
            )),
            SizedBox(width: 16),
            SizedBox(
              width: 40,
              child: TextButton(
                onPressed: () => {_removeDrug(i)},
                child: Icon(Icons.delete, color: Colors.grey),
              ),
            )
          ],
        ),
      ));
    }
    return drugsWidgets;
  }

  void _togglePassword() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;
    });
  }

  void _toggleConfirmationPassword() {
    setState(() {
      _obscuredConfirmationPassword = !_obscuredConfirmationPassword;
    });
  }

  void _selectDate(BuildContext context) async {
    final ThemeData themeData = Theme.of(context);
    assert(themeData.platform != null);

    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  void buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: this.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('pt', 'PT'),
      initialDatePickerMode: DatePickerMode.year,
      cancelText: 'Cancelar',
      fieldLabelText: 'Data de Nascimento',
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void buildCupertinoDatePicker(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 1900,
              maximumDate: DateTime.now(),
            ),
          );
        });
  }

  Future<void> _showAcceptanceTermsModal() async {
    if (_isLoading) return;

    if (usfId == null) {
      appWidget.showSnackbar(
          "Selecione uma Instituição", Colors.red, _scaffoldKey);
      return;
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(this.terms.title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    this.terms.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Aceito os Termos e Condições'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _register();
                },
              ),
            ],
          );
        });
  }

  void _loadDataFromServer() async {
    List<Usf> list = [];
    List<String> diseasesList = [];
    List<String> alergiesList = [];

    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    var message = ERROR_GENERAL_API;
    var isShowMessage = false;

    try {
      var response = await Network().getWithoutAuth(USF_URL);
      var responseTerms = await Network().getWithoutAuth(TERMS_URL);
      var responseDiseases = await Network().getWithoutAuth(DISEASES_URL);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(response.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Usf usf = Usf.fromJson(element);
          list.add(usf);
        });

        this.setState(() {
          usfs = list;
        });
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }

      if (responseTerms.statusCode == RESPONSE_SUCCESS) {
        var data = AcceptanceTerms.fromJson(
            json.decode(responseTerms.body)[JSON_DATA_KEY]);

        this.setState(() {
          terms = data;
        });
      } else {
        isShowMessage = true;
      }

      if (responseDiseases.statusCode == RESPONSE_SUCCESS) {
        List<dynamic> data = json.decode(responseDiseases.body)[JSON_DATA_KEY];

        data.forEach((element) {
          Disease d = Disease.fromJson(element);
          if (d.type == 'A') {
            alergiesList.add(d.name);
          } else {
            diseasesList.add(d.name);
          }
        });

        this.setState(() {
          diseasesOptions = diseasesList;
          allergiesOptions = alergiesList;
        });
      } else {
        isShowMessage = true;
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage)
      appWidget.showSnackbar(message, Colors.red, _scaffoldKey);

    setState(() {
      _isLoading = false;
    });
  }

  void _register() async {
    if (_isLoading) return;

    this.setState(() {
      _isLoading = true;
    });

    var diseasesStr = "";
    var message = ERROR_GENERAL_API;
    var isShowMessage = false;

    diseases.forEach((element) {
      diseasesStr += "$element,";
    });
    var user = User();
    user.name = name;
    user.email = email;
    user.gender = gender;
    user.birthday = selectedDate.toIso8601String();
    user.height = height;
    user.weight = weight;
    user.diseases = diseasesStr;
    user.ufc_id = usfId;

    try {
      var response = await Network()
          .registerUser(user, _image, password, drugs, REGISTER_URL);

      var body = json.decode(response.body);

      if (response.statusCode == RESPONSE_SUCCESS_201) {
        response = await Network()
            .postWithoutAuth({'email': email, 'password': password}, LOGIN_URL);
        body = json.decode(response.body);

        if (response.statusCode == RESPONSE_SUCCESS) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString(LOCAL_STORAGE_TOKEN_KEY,
              json.encode(body[JSON_ACCESS_TOKEN_KEY]));

          response = await Network().getWithAuth(USERS_ME_URL);

          if (response.statusCode == RESPONSE_SUCCESS) {
            var data = json.decode(response.body)[JSON_DATA_KEY];
            localStorage.setString(LOCAL_STORAGE_USER_KEY, json.encode(data));
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else {
            isShowMessage = true;
            if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
          }
        } else {
          isShowMessage = true;
          if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
        }
      } else {
        isShowMessage = true;
        if (body[JSON_ERROR_KEY] != null) message = (body[JSON_ERROR_KEY]);
      }
    } catch (error) {
      isShowMessage = true;
    }

    if (isShowMessage)
      appWidget.showSnackbar(message, Colors.red, _scaffoldKey);

    setState(() {
      _isLoading = false;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria de Imagens'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmara'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
}
