import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "",
      appId: "",
      messagingSenderId: "",
      projectId: "",
      databaseURL:
          "",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ProdutoForm());
  }
}

class ProdutoForm extends StatefulWidget {
  @override
  _ProdutoFormState createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _adicionarProduto() async {
    final String codigo = _codigoController.text;
    final String nome = _nomeController.text;
    final String descricao = _descricaoController.text;
    final double? valor = double.tryParse(_valorController.text);

    if (codigo.isNotEmpty &&
        nome.isNotEmpty &&
        descricao.isNotEmpty &&
        valor != null) {
      try {
        await _database.child('produtos').push().set({
          'codigo': codigo,
          'nome': nome,
          'descricao': descricao,
          'valor': valor,
        });

        setState(() {
          _codigoController.clear();
          _nomeController.clear();
          _descricaoController.clear();
          _valorController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto adicionado com sucesso!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar produto: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código'),
            TextField(controller: _codigoController),
            SizedBox(height: 12),
            Text('Nome do Produto'),
            TextField(controller: _nomeController),
            SizedBox(height: 12),
            Text('Descrição'),
            TextField(controller: _descricaoController),
            SizedBox(height: 12),
            Text('Valor'),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _adicionarProduto,
                child: Text('Adicionar Produto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }
}
