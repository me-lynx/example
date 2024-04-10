import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class OrdemDeServico {
  final String nome;
  final String cpf;
  final DateTime dataCriacao;

  OrdemDeServico({
    required this.nome,
    required this.cpf,
    required this.dataCriacao,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista com Filtros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaPage(),
    );
  }
}

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  late List<OrdemDeServico> ordensDeServico;
  late List<OrdemDeServico> filteredList;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    ordensDeServico = [
      OrdemDeServico(
          nome: 'João',
          cpf: '111.111.111-11',
          dataCriacao: DateTime(2024, 3, 10)),
      OrdemDeServico(
          nome: 'Maria',
          cpf: '222.222.222-22',
          dataCriacao: DateTime(2024, 3, 15)),
      OrdemDeServico(
          nome: 'Pedro',
          cpf: '333.333.333-33',
          dataCriacao: DateTime(2024, 3, 20)),
    ];
    filteredList = ordensDeServico;
    selectedDate = DateTime.now();
  }

  void filterList({String? nome, String? cpf, DateTime? dataCriacao}) {
    setState(() {
      filteredList = ordensDeServico.where((ordem) {
        return (nome == null ||
                ordem.nome.toLowerCase().contains(nome.toLowerCase())) &&
            (cpf == null ||
                ordem.cpf.toLowerCase().contains(cpf.toLowerCase())) &&
            (dataCriacao == null || ordem.dataCriacao == dataCriacao);
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      filterList(dataCriacao: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista com Filtros'),
      ),
      body: Column(
        children: [
          TextFormField(
            onChanged: (value) => filterList(nome: value),
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextFormField(
            onChanged: (value) => filterList(cpf: value),
            decoration: const InputDecoration(labelText: 'CPF'),
          ),
          ListTile(
            title: const Text('Data de Criação'),
            subtitle: Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            ),
            onTap: () => _selectDate(context),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final ordem = filteredList[index];
                return ListTile(
                  title: Text(ordem.nome),
                  subtitle: Text(
                      'CPF: ${ordem.cpf}, Criado em: ${ordem.dataCriacao.day}/${ordem.dataCriacao.month}/${ordem.dataCriacao.year}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
