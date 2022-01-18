/*
Nome: Gabriel Henrique da Silva Servini RA: 2920481921018
Nome: Jonathan Joaquim Pereira da Silva RA: 2920481921015
Nome: Newton Paul Aranha RA: 2920481921014
Nome: Vinicius de Oliveira Santos RA: 2920481921039
Nome: Wesley Lima Dias do Vale RA: 2920481921009

Objetivos:Utilizando o aplicativo da aula 12 – Moedas, 
fazer a seguinte alteração:
Proponha e faça mais algumas alterações (no mínimo 3 alterações):
I. Mudar a cor do aplicativo;
II.Adicionar conversão de ienes japoneses e bitcoin;
III. Adicionar botão de refresh;
IV. Tirar a faixinha de debug
V. Validar campo vazio
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:app_03_moedas/themeController.dart';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(
    AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(),
          theme: ThemeData(
            hintColor: Colors.green,
            primarySwatch: Colors.green,
            brightness: ThemeController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              hintStyle: TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final ieneController = TextEditingController();
  final bitController = TextEditingController();

  late double dolar;
  late double euro;
  late double iene;
  late double bitcoin;

  void _limpaCampos() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
    ieneController.text = '';
    bitController.text = '';
  }

  void _realChanged(String texto) {
    if (texto != '') {
      double real = double.parse(texto);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
      ieneController.text = (real / iene).toStringAsFixed(2);
      bitController.text = (real / bitcoin).toStringAsFixed(4);
    } else {
      dolarController.text = '';
      euroController.text = '';
      ieneController.text = '';
      bitController.text = '';
    }
  }

  void _dolarChanged(String texto) {
    if (texto != '') {
      double _dolar = double.parse(texto);
      realController.text = (_dolar * dolar).toStringAsFixed(2);
      euroController.text = (_dolar * dolar / euro).toStringAsFixed(2);
      ieneController.text = (_dolar * dolar / iene).toStringAsFixed(2);
      bitController.text = (_dolar * dolar / bitcoin).toStringAsFixed(4);
    } else {
      realController.text = '';
      euroController.text = '';
      ieneController.text = '';
      bitController.text = '';
    }
  }

  void _euroChanged(String texto) {
    if (texto != '') {
      double _euro = double.parse(texto);
      realController.text = (_euro * euro).toStringAsFixed(2);
      dolarController.text = (_euro * euro / dolar).toStringAsFixed(2);
      ieneController.text = (_euro * euro / iene).toStringAsFixed(2);
      bitController.text = (_euro * euro / bitcoin).toStringAsFixed(4);
    } else {
      dolarController.text = '';
      realController.text = '';
      ieneController.text = '';
      bitController.text = '';
    }
  }

  void _ieneChanged(String texto) {
    if (texto != '') {
      double _iene = double.parse(texto);
      realController.text = (_iene * iene).toStringAsFixed(2);
      dolarController.text = (_iene * iene / dolar).toStringAsFixed(2);
      euroController.text = (_iene * iene / euro).toStringAsFixed(2);
      bitController.text = (_iene * iene / bitcoin).toStringAsFixed(4);
    } else {
      dolarController.text = '';
      euroController.text = '';
      realController.text = '';
      bitController.text = '';
    }
  }

  void _bitChanged(String texto) {
    if (texto != '') {
      double _bitcoin = double.parse(texto);
      realController.text = (_bitcoin * bitcoin).toStringAsFixed(2);
      dolarController.text = (_bitcoin * bitcoin / dolar).toStringAsFixed(2);
      ieneController.text = (_bitcoin * bitcoin / iene).toStringAsFixed(2);
      euroController.text = (_bitcoin * bitcoin / euro).toStringAsFixed(2);
    } else {
      dolarController.text = '';
      euroController.text = '';
      ieneController.text = '';
      realController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        centerTitle: true,
        actions: [
          CustomSwitch(),
          IconButton(
            onPressed: _limpaCampos,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: pegarDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar os Dados",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                iene = snapshot.data!["results"]["currencies"]["JPY"]["buy"];
                bitcoin = snapshot.data!["results"]["currencies"]["BTC"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.green,
                      ),
                      construirTextField(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      construirTextField(
                          "Dolares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      construirTextField(
                          "Euros", "€", euroController, _euroChanged),
                      Divider(),
                      construirTextField(
                          "Ienes", "¥", ieneController, _ieneChanged),
                      Divider(),
                      construirTextField(
                          "BitCoins", "₿", bitController, _bitChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget construirTextField(String texto, String prefixo, TextEditingController c,
    Function(String)? f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: texto,
      labelStyle: TextStyle(color: Colors.green),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(
      color: Colors.green,
      fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

Future<Map> pegarDados() async {
  final http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(ThemeController.instance.icon),
      onPressed: () {
        ThemeController.instance.changeTheme();
      },
    );
  }
}
