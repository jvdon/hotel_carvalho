import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_carvalho/databases/reserva_db.dart';
import 'package:hotel_carvalho/models/reserva.dart';
import 'package:hotel_carvalho/pages/cadastro_page.dart';
import 'package:intl/intl.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CadastroPage(),
            ),
          );
        },
      ),
      body: FutureBuilder<List<Reserva>>(
        future: ReservaDB().reservas(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
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
                List<Reserva> reservas = snapshot.data!;
                if (reservas.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search),
                        Text("Nenhuma reserva encontrada"),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: reservas.length,
                    itemBuilder: (context, index) {
                      Reserva reserva = reservas[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(reserva.quartos.map((e) => e.number).join(" ")),
                        ),
                        title: Text("Valor: ${reserva.valor} | ${reserva.hospedes.first.nome}"),
                        subtitle: Text(
                            "KPA: ${reserva.hospedes.length} | Checkin: ${DateFormat("d/MM/y").format(reserva.checkin)} | Checkout: ${DateFormat("d/MM/y").format(reserva.checkout)}"),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [],
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
    );
  }
}
