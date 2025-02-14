import 'package:applicationplanets/controles/controle_planeta.dart';
import 'package:applicationplanets/telas/tela_planeta.dart';
import 'package:flutter/material.dart';

import 'modelos/planeta.dart';

//import 'modelos/planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planeta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'App - Planetas',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _lerPlanetas();
  }

  Future<void> _lerPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TelaPlaneta(
                isIncluir: true,
                planeta: Planeta.vazio(),
                onFinalizado: () {
                  _lerPlanetas();
                },
              )),
    );
  }

  void _alterarPlaneta(context,Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TelaPlaneta(
                isIncluir: false,
                planeta: planeta,
                onFinalizado: () {
                  _lerPlanetas();
                },
              )),
    );
  }


  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _lerPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
              title: Text(planeta.nome),
              subtitle: Text(planeta.apelido!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit),
                  onPressed:() => _alterarPlaneta(context, planeta),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirPlaneta(planeta.id!),
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incluirPlaneta(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
