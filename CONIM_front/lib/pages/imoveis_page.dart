import 'package:flutter/material.dart';
import '../api/imovel_api.dart';
import '../widgets/imovel_card.dart';
import 'imovel_form_page.dart';

class ImoveisPage extends StatefulWidget {
  const ImoveisPage({super.key});

  @override
  State<ImoveisPage> createState() => _ImoveisPageState();
}

class _ImoveisPageState extends State<ImoveisPage> {
  final ImovelApi api = ImovelApi();
  late Future<List<dynamic>> imoveis;

  @override
  void initState() {
    super.initState();
    carregarImoveis();
  }

  void carregarImoveis() {
    imoveis = api.listar(); // usa o mesmo nome do back-end
  }

  // ------------------------------
  // MOSTRAR DETALHES DO IMÓVEL
  // ------------------------------
  void _mostrarDetalhes(Map<String, dynamic> imovel) async {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${imovel["cidade"]}, ${imovel["bairro"]}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Endereço: ${imovel["endereco"]}, ${imovel["numero"]}"),
              Text("CEP: ${imovel["CEP"]}"),
              Text("Quartos: ${imovel["quartos"]}"),
              Text("Banheiros: ${imovel["banheiros"]}"),
              Text("Área: ${imovel["area"]} m²"),
              Text("Valor aluguel: R\$ ${imovel["valorAluguel"]}"),
              Text("Status: ${imovel["statusImovel"]}"),
              Text("Observações: ${imovel["observacoes"] ?? '-'}"),
            ],
          ),
        ),
        actions: [
          // BOTÃO EDITAR
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // fecha o dialog antes do await
              _editarImovel(imovel);
            },
            child: const Text("Editar"),
          ),
          // BOTÃO EXCLUIR
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // fecha o dialog antes do await
              _excluirImovel(imovel);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // FUNÇÃO EDITAR
  // ------------------------------
  void _editarImovel(Map<String, dynamic> imovel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ImovelFormPage(imovel: imovel)),
    );
    if (!mounted) return;
    if (result == true) setState(() => carregarImoveis());
  }

  // ------------------------------
  // FUNÇÃO EXCLUIR
  // ------------------------------
  void _excluirImovel(Map<String, dynamic> imovel) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Deseja realmente excluir este imóvel?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await api.remover((imovel["id"] as num).toInt());
        if (!mounted) return;
        setState(() => carregarImoveis());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imóvel excluído com sucesso")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir imóvel: $e")),
        );
      }
    }
  }

  // ------------------------------
  // CADASTRAR NOVO IMÓVEL
  // ------------------------------
  void _cadastrarNovo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImovelFormPage()),
    );

    if (!mounted) return;
    if (result == true) {
      setState(() {
        carregarImoveis();
      });
    }
  }

  // ------------------------------
  // BUILD
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imóveis Cadastrados"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _cadastrarNovo,
            icon: const Icon(Icons.add, color: Colors.blue),
          )
        ],
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: FutureBuilder<List<dynamic>>(
        future: imoveis,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum imóvel encontrado"));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: data.length,
              itemBuilder: (_, index) {
                final imovel = data[index];
                return ImovelCard(
                  imovel: imovel,
                  onTap: () => _mostrarDetalhes(imovel),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
