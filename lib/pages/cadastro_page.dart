// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotel_carvalho/databases/quarto_db.dart';
import 'package:hotel_carvalho/databases/reserva_db.dart';
import 'package:hotel_carvalho/models/hospede.dart';
import 'package:hotel_carvalho/models/quarto.dart';
import 'package:hotel_carvalho/models/reserva.dart';
import 'package:hotel_carvalho/partials/TextInput.dart';
import 'package:intl/intl.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  TextEditingController valor = TextEditingController();
  TextEditingController checkin = TextEditingController();
  TextEditingController checkout = TextEditingController();

  List<Hospede> hospedes = [];
  List<Quarto> quartosSelected = [];

  double precoQuarto = 70;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Reserva"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 150,
                child: FutureBuilder(
                  future: QuartoDB().quartos(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator(
                          color: Colors.green,
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.exclamationmark),
                                Text("Error fetching data ${snapshot.error.toString()}"),
                              ],
                            ),
                          );
                        } else {
                          List<Quarto> quartos = snapshot.requireData;

                          return Column(
                            children: [
                              Container(
                                height: 80,
                                width: 200,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    label: Text("Quartos"),
                                    border: OutlineInputBorder(),
                                  ),
                                  child: ListView.builder(
                                    itemCount: quartosSelected.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      Quarto quarto = quartosSelected[index];
                                      return GestureDetector(
                                        onTap: () {
                                          quartosSelected.remove(quarto);
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 50,
                                          child: Column(
                                            children: [
                                              Icon(Icons.bed),
                                              Text(quarto.number.toString()),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              DropdownMenu(
                                onSelected: (value) {
                                  if (value != null) {
                                    if (quartosSelected.contains(value) == false) {
                                      quartosSelected.add(value);
                                    }
                                  }
                                  setState(() {});
                                },
                                label: Text("Quarto"),
                                width: 200,
                                dropdownMenuEntries: quartos.map(
                                  (e) {
                                    return DropdownMenuEntry(value: e, label: e.number.toString());
                                  },
                                ).toList(),
                              ),
                            ],
                          );
                        }
                      default:
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.question),
                              Text("Oops something went wrong"),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 400,
                height: 130,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    label: Text("Hospedes"),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: hospedes.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Hospede hospede = hospedes[index];
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                              child: Column(
                                children: [
                                  const Icon(Icons.person),
                                  Text(hospede.nome),
                                  IconButton(
                                    onPressed: () {
                                      hospedes.remove(hospede);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_add, size: 36),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController nome = TextEditingController();
                              TextEditingController cpf = TextEditingController();

                              return Dialog(
                                child: Container(
                                  height: 230,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Adicionar hospede",
                                        textAlign: TextAlign.center,
                                      ),
                                      TextInput(label: "Nome", controller: nome, width: 300, maxLength: 100),
                                      TextInput(label: "CPF", controller: cpf, width: 300, maxLength: 15),
                                      IconButton(
                                        onPressed: () {
                                          Hospede hospede = Hospede(nome: nome.text, cpf: cpf.text);

                                          hospedes.add(hospede);

                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.person_add,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).then(
                            (value) {
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(Duration(days: 15)),
                          lastDate: DateTime.now().add(Duration(days: 45)),
                        );
                        if (dateTime != null) {
                          setState(() {
                            checkin.text = dateTime.toIso8601String();
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          label: Text("Checkin"),
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            if (checkin.text.isNotEmpty)
                              Text(DateFormat("d/MM/y").format(DateTime.parse(checkin.text))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(Duration(days: 15)),
                          lastDate: DateTime.now().add(Duration(days: 45)),
                        );
                        if (dateTime != null) {
                          setState(() {
                            checkout.text = dateTime.toIso8601String();
                            valor.text = (precoQuarto *
                                    hospedes.length *
                                    (dateTime.difference((DateTime.parse(checkin.text))).inDays))
                                .toString();
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          label: Text("Checkout"),
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            if (checkout.text.isNotEmpty)
                              Text(DateFormat("d/MM/y").format(DateTime.parse(checkout.text))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextInput(label: "Valor", controller: valor, width: 400, maxLength: 10),
              IconButton(
                  color: Colors.green,
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        hospedes.isNotEmpty &&
                        quartosSelected.isNotEmpty &&
                        checkin.text.isNotEmpty &&
                        checkout.text.isNotEmpty) {
                      Map<String, Object?> reserva = {
                        "hospedes": jsonEncode(hospedes.map((x) => x.toMap()).toList()),
                        "quartos": jsonEncode(quartosSelected.map((x) => x.toMap()).toList()),
                        "checkin": DateTime.parse(checkin.text).millisecondsSinceEpoch,
                        "checkout": DateTime.parse(checkout.text).millisecondsSinceEpoch,
                        "valor": double.parse(valor.text),
                      };

                      await ReservaDB().insertReserva(reserva);
                      print("Valido");
                    }
                  },
                  icon: Icon(Icons.save))
            ],
          ),
        ),
      ),
    );
  }
}
