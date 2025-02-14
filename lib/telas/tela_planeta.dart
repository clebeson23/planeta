import 'package:applicationplanets/controles/controle_planeta.dart';
import 'package:flutter/material.dart';

import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.onFinalizado,
    required this.planeta,
    required this.isIncluir,
  });
  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  //gerencia o que está sendo digitado no campo de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _nikeNameController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nameController.text = _planeta.nome;
    _sizeController.text = _planeta.tamanho.toString();
    _distanceController.text = _planeta.distancia.toString();
    _nikeNameController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _distanceController.dispose();
    _nikeNameController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Dados do planeta foram ${widget.isIncluir ? 'incluidos' : 'alterados'} com sucesso!')));
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Cadastrar Planeta'),
          elevation: 3,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do planeta';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planeta.nome = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _sizeController,
                      decoration: InputDecoration(
                          labelText: 'Tamanho(em km)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o tamanho do planeta';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, insira um valor válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planeta.tamanho = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _distanceController,
                      decoration: InputDecoration(
                          labelText: 'Distância da Terra(em km)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a distância do planeta';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, insira um valor válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planeta.distancia = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nikeNameController,
                      decoration: InputDecoration(
                          labelText: 'Apelido',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      onSaved: (value) {
                        _planeta.apelido = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}
