import 'package:flutter/material.dart';
import '../api/inquilino_api.dart';
import '../widgets/inquilino_card.dart';
import 'inquilino_form_page.dart';

class InquilinosPage extends StatefulWidget {
  const InquilinosPage({super.key});

  @override
  State<InquilinosPage> createState() => _InquilinosPageState();
}

class _InquilinosPageState extends State<InquilinosPage> {
  final InquilinoApi api = InquilinoApi();
  late Future<List<dynamic>> inquilinosFuture;

  @override
  void initState() {
    super.initState();
    carregarInquilinos();
  }

  void carregarInquilinos() {
    inquilinosFuture = api.listar();
  }

  Future<void> _refresh() async {
    setState(() {
      carregarInquilinos();
    });
    await inquilinosFuture;
  }

  Future<void> _openInquilinoDialog([Map<String, dynamic>? inquilino]) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.85,
            child: InquilinoFormPage(inquilino: inquilino),
          ),
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        carregarInquilinos();
      });
    }
  }

  void _mostrarDetalhes(Map<String, dynamic> inquilino) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(inquilino["nome"]),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Documento: ${inquilino["documento"]}"),
              const SizedBox(height: 6),
              Text("Email: ${inquilino["email"] ?? '-'}"),
              Text("Telefone: ${inquilino["telefone"] ?? '-'}"),
              Text("Renda: R\$ ${inquilino["rendaMensal"] ?? '0.00'}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openInquilinoDialog(inquilino);
            },
            child: const Text("Editar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _excluirInquilino(inquilino);
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

  Future<void> _excluirInquilino(Map<String, dynamic> inquilino) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Deseja realmente excluir este inquilino?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await api.remover((inquilino["id"] as num).toInt());
        if (!mounted) return;
        setState(() {
          carregarInquilinos();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquilino excluído com sucesso")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir inquilino: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _AppSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const _PageHeaderTitle(),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _openInquilinoDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Novo Inquilino"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: inquilinosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(child: Text("Nenhum inquilino encontrado")),
                ],
              );
            }

            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: InquilinoList(
                inquilinos: data,
                onTap: (inquilino) => _mostrarDetalhes(inquilino),
                onEdit: (inquilino) => _openInquilinoDialog(inquilino),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AppSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              child: Text(
                "CONIM",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Início"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Clientes"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Configurações"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Versão 1.0",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeaderTitle extends StatelessWidget {
  const _PageHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Gestão de Inquilinos",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Gerencie todos os inquilinos do sistema",
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}

class InquilinoList extends StatelessWidget {
  final List<dynamic> inquilinos;
  final void Function(Map<String, dynamic>)? onTap;
  final void Function(Map<String, dynamic>)? onEdit;

  const InquilinoList({
    super.key,
    required this.inquilinos,
    this.onTap,
    this.onEdit,
  });

  int _columnsForWidth(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _columnsForWidth(constraints.maxWidth);
        return GridView.builder(
          itemCount: inquilinos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: 0.9,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (_, index) {
            final inquilino = Map<String, dynamic>.from(
                inquilinos[index] as Map);
            return GestureDetector(
              onTap: () => onTap?.call(inquilino),
              child: InquilinoCard(
                inquilino: inquilino,
                onEdit: () => onEdit?.call(inquilino),
              ),
            );
          },
        );
      },
    );
  }
}