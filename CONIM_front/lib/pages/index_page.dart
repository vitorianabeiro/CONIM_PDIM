import 'package:flutter/material.dart';
import 'imoveis_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de módulos
    final List<_Modulo> modulos = [
      _Modulo(
        nome: "Imóveis",
        icone: Icons.home_work,
        cor: Colors.blue,
        funcional: true,
      ),
      _Modulo(
        nome: "Clientes",
        icone: Icons.people,
        cor: Colors.orange,
        funcional: false,
      ),
      _Modulo(
        nome: "Contratos",
        icone: Icons.assignment,
        cor: Colors.green,
        funcional: false,
      ),
      _Modulo(
        nome: "Pagamentos",
        icone: Icons.payment,
        cor: Colors.purple,
        funcional: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Contract Imóvel",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bem-vindo ao Contract Imóvel!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: modulos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (_, index) {
                  final modulo = modulos[index];
                  return GestureDetector(
                    onTap: () {
                      if (modulo.funcional) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ImoveisPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("${modulo.nome} ainda não implementado")),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: modulo.cor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(modulo.icone, size: 60, color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            modulo.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe interna para os módulos
class _Modulo {
  final String nome;
  final IconData icone;
  final Color cor;
  final bool funcional;

  _Modulo({
    required this.nome,
    required this.icone,
    required this.cor,
    this.funcional = false,
  });
}
