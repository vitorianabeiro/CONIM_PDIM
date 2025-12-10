import 'package:flutter/material.dart';
import '../api/inquilino_api.dart';

class InquilinoFormPage extends StatefulWidget {
  final Map<String, dynamic>? inquilino;

  const InquilinoFormPage({super.key, this.inquilino});

  @override
  State<InquilinoFormPage> createState() => _InquilinoFormPageState();
}

class _InquilinoFormPageState extends State<InquilinoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final InquilinoApi api = InquilinoApi();

  late TextEditingController nomeController;
  late TextEditingController cpfController;
  late TextEditingController rgController;
  late TextEditingController orgaoEmissorController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;
  late TextEditingController profissaoController;
  late TextEditingController rendaController;
  late TextEditingController logradouroController;
  late TextEditingController numeroController;
  late TextEditingController bairroController;
  late TextEditingController cidadeController;
  late TextEditingController estadoController;
  late TextEditingController cepController;

  late String estadoCivil;

  @override
  void initState() {
    super.initState();

    final inquilino = widget.inquilino;
    nomeController = TextEditingController(text: inquilino?["nome"]);
    cpfController = TextEditingController(text: inquilino?["documento"]);
    rgController = TextEditingController(text: inquilino?["rg"]);
    orgaoEmissorController = TextEditingController(
        text: inquilino?["orgaoEmissor"]);
    emailController = TextEditingController(text: inquilino?["email"]);
    telefoneController = TextEditingController(text: inquilino?["telefone"]);
    profissaoController = TextEditingController(text: inquilino?["profissao"]);
    rendaController = TextEditingController(
        text: inquilino?["rendaMensal"]?.toString());
    logradouroController = TextEditingController(
        text: inquilino?["logradouro"]);
    numeroController = TextEditingController(text: inquilino?["numero"]);
    bairroController = TextEditingController(text: inquilino?["bairro"]);
    cidadeController = TextEditingController(text: inquilino?["cidade"]);
    estadoController = TextEditingController(text: inquilino?["estado"]);
    cepController = TextEditingController(text: inquilino?["cep"]);
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final inquilinoData = {
      "nome": nomeController.text,
      "Documento": cpfController.text,
      "rg": rgController.text,
      "orgaoEmissor": orgaoEmissorController.text,
      "email": emailController.text,
      "telefone": telefoneController.text,
      "profissao": profissaoController.text,
      "renda": double.tryParse(rendaController.text) ?? 0,
      "estadoCivil": estadoCivil,
      "logradouro": logradouroController.text,
      "numero": numeroController.text,
      "bairro": bairroController.text,
      "cidade": cidadeController.text,
      "estado": estadoController.text,
      "cep": cepController.text,
    };

    try {
      if (widget.inquilino == null) {
        await api.inserir(inquilinoData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquilino cadastrado com sucesso")),
        );
      } else {

        await api.atualizar(
            (widget.inquilino!["id"] as num).toInt(), inquilinoData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquilino atualizado com sucesso")),
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar inquilino: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inquilino == null
            ? "Cadastrar Inquilino"
            : "Editar Inquilino"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Dados Pessoais",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField("Nome *", nomeController),
              _buildTextField("Documento *", cpfController),
              _buildTextField("Email", emailController,
                  keyboard: TextInputType.emailAddress),
              _buildTextField("Telefone", telefoneController,
                  keyboard: TextInputType.phone),
              _buildTextField("Renda (R\$)", rendaController,
                  keyboard: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  widget.inquilino == null ? "Cadastrar" : "Atualizar",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) {
          if (label.contains('*') && (val == null || val.isEmpty)) {
            return "Campo obrigatório";
          }
          return null;
        },
      ),
    );
  }
}