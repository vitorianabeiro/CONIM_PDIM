import 'package:flutter/material.dart';
import '../api/imovel_api.dart';

class ImovelFormPage extends StatefulWidget {
  final Map<String, dynamic>? imovel; // se for null, é cadastro

  const ImovelFormPage({super.key, this.imovel});

  @override
  State<ImovelFormPage> createState() => _ImovelFormPageState();
}

class _ImovelFormPageState extends State<ImovelFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImovelApi api = ImovelApi();

  late TextEditingController cidadeController;
  late TextEditingController bairroController;
  late TextEditingController enderecoController;
  late TextEditingController numeroController;
  late TextEditingController cepController;
  late TextEditingController valorController;
  late TextEditingController quartosController;
  late TextEditingController banheirosController;
  late TextEditingController areaController;
  late TextEditingController observacoesController;

  late String status;

  // Lista fixa de status baseada nos enums do back
  final List<String> statusOptions = [
    "ALUGADO",
    "COMPRADO",
    "INTERDITADO",
    "REFORMA",
    "DISPONIVEL",
    "VENDIDO",
  ];

  @override
  void initState() {
    super.initState();

    final imovel = widget.imovel;
    cidadeController = TextEditingController(text: imovel?["cidade"]);
    bairroController = TextEditingController(text: imovel?["bairro"]);
    enderecoController = TextEditingController(text: imovel?["endereco"]);
    numeroController = TextEditingController(text: imovel?["numero"]);
    cepController = TextEditingController(text: imovel?["CEP"]);
    valorController = TextEditingController(text: imovel?["valorAluguel"]?.toString());
    quartosController = TextEditingController(text: imovel?["quartos"]?.toString());
    banheirosController = TextEditingController(text: imovel?["banheiros"]?.toString());
    areaController = TextEditingController(text: imovel?["area"]?.toString());
    observacoesController = TextEditingController(text: imovel?["observacoes"]);
    status = imovel?["statusImovel"] ?? "DISPONIVEL";
  }

  // ------------------------------
  // SALVAR OU ATUALIZAR
  // ------------------------------
  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final imovelData = {
      "cidade": cidadeController.text,
      "bairro": bairroController.text,
      "endereco": enderecoController.text,
      "numero": numeroController.text,
      "CEP": cepController.text,
      "valorAluguel": double.tryParse(valorController.text) ?? 0,
      "quartos": int.tryParse(quartosController.text) ?? 0,
      "banheiros": int.tryParse(banheirosController.text) ?? 0,
      "area": double.tryParse(areaController.text) ?? 0,
      "observacoes": observacoesController.text,
      "statusImovel": status,
    };

    try {
      if (widget.imovel == null) {
        // Cadastrar novo imóvel
        await api.inserir(imovelData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imóvel cadastrado com sucesso")),
        );
      } else {
        // Atualizar imóvel existente
        await api.atualizar((widget.imovel!["id"] as num).toInt(), imovelData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imóvel atualizado com sucesso")),
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true); // retorna para a lista
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar imóvel: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imovel == null ? "Cadastrar Imóvel" : "Editar Imóvel"),
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
              _buildTextField("Cidade", cidadeController),
              _buildTextField("Bairro", bairroController),
              _buildTextField("Endereço", enderecoController),
              _buildTextField("Número", numeroController),
              _buildTextField("CEP", cepController),
              _buildTextField("Valor Aluguel", valorController, keyboard: TextInputType.number),
              _buildTextField("Quartos", quartosController, keyboard: TextInputType.number),
              _buildTextField("Banheiros", banheirosController, keyboard: TextInputType.number),
              _buildTextField("Área (m²)", areaController, keyboard: TextInputType.number),
              _buildTextField("Observações", observacoesController, maxLines: 3),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: status,
                items: statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => status = val!),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(widget.imovel == null ? "Cadastrar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }
}
