import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_carvalho/databases/quarto_db.dart';
import 'package:hotel_carvalho/models/quarto.dart';
import 'package:hotel_carvalho/partials/TextInput.dart';

class QuartosPage extends StatefulWidget {
  const QuartosPage({super.key});

  @override
  State<QuartosPage> createState() => _QuartosPageState();
}

class _QuartosPageState extends State<QuartosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quartos"),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.refresh),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
      body: FutureBuilder<List<Quarto>>(
        future: QuartoDB().quartos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
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
                List<Quarto> quartos = snapshot.data!;

                quartos.sort(
                  (a, b) => a.number.compareTo(b.number),
                );

                if (quartos.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search),
                        Text("Nenhum Quarto encontrado"),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: quartos.length,
                    itemBuilder: (context, index) {
                      Quarto quarto = quartos[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: StatusColors[quarto.status],
                        ),
                        title: Text("Quarto #${quarto.number}"),
                        subtitle: Text("Capacidade: ${quarto.occupancy}"),
                        trailing: Container(
                          width: 120,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(CupertinoIcons.trash),
                                tooltip: "Deletar quarto",
                                onPressed: () async {
                                  QuartoDB().deleteQuarto(quarto);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(CupertinoIcons.pencil),
                                tooltip: "Editar quarto",
                                onPressed: () async {
                                  TextEditingController number = TextEditingController(text: quarto.number.toString());
                                  TextEditingController occupancy =
                                      TextEditingController(text: quarto.occupancy.toString());
                                  TextEditingController status = TextEditingController(text: quarto.status.name);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final _formKey = GlobalKey<FormState>();
                                      return StatefulBuilder(
                                        builder: (BuildContext context, setState) {
                                          return Dialog(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.height * 0.3,
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    TextInput(
                                                      label: "Number",
                                                      controller: number,
                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextInput(
                                                      label: "Capacidade",
                                                      controller: occupancy,
                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                    ),
                                                    const SizedBox(height: 15),
                                                    DropdownMenu(
                                                      controller: status,
                                                      initialSelection: "LIVRE",
                                                      label: Text("Status"),
                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                      dropdownMenuEntries: QuartoStatus.values
                                                          .map(
                                                            (e) => DropdownMenuEntry(value: e.name, label: e.name),
                                                          )
                                                          .toList(),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    IconButton(
                                                      onPressed: () async {
                                                        if (_formKey.currentState!.validate()) {
                                                          int numberInt = int.parse(number.text);
                                                          int occuInt = int.parse(occupancy.text);
                                                          QuartoStatus quartoStatus =
                                                              QuartoStatus.values.byName(status.text);

                                                          Quarto upQuarto = Quarto(
                                                            id: quarto.id,
                                                            number: numberInt,
                                                            occupancy: occuInt,
                                                            status: quartoStatus,
                                                          );

                                                          QuartoDB().updateQuarto(upQuarto, quarto.id);

                                                          Navigator.pop(context);
                                                        }
                                                      },
                                                      icon: Icon(Icons.save),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              if (quarto.status == QuartoStatus.USADO)
                                IconButton(
                                  tooltip: "Limpar Quarto",
                                  icon: const Icon(Icons.cleaning_services_outlined),
                                  onPressed: () async {
                                    QuartoDB().limparQuarto(quarto.id, QuartoStatus.LIVRE);
                                    setState(() {});
                                  },
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          size: 48,
        ),
        onPressed: () {
          TextEditingController number = TextEditingController();
          TextEditingController occupancy = TextEditingController();
          TextEditingController status = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              final _formKey = GlobalKey<FormState>();
              return StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Dialog(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextInput(
                              label: "Number",
                              controller: number,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            const SizedBox(height: 10),
                            TextInput(
                              label: "Capacidade",
                              controller: occupancy,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            const SizedBox(height: 15),
                            DropdownMenu(
                              controller: status,
                              initialSelection: "LIVRE",
                              label: Text("Status"),
                              width: MediaQuery.of(context).size.width * 0.5,
                              dropdownMenuEntries: QuartoStatus.values
                                  .map(
                                    (e) => DropdownMenuEntry(value: e.name, label: e.name),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 15),
                            IconButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  int numberInt = int.parse(number.text);
                                  int occuInt = int.parse(occupancy.text);
                                  QuartoStatus quartoStatus = QuartoStatus.values.byName(status.text);

                                  Map<String, Object?> quarto = {
                                    "number": numberInt,
                                    "occupancy": occuInt,
                                    "status": quartoStatus.name,
                                  };

                                  QuartoDB().insertQuarto(quarto);

                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(Icons.save),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).then(
            (value) {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
