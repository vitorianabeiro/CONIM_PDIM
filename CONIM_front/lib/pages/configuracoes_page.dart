import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {

  bool emailNotificacoes = true;
  bool modoEscuro = true;
  bool alertasVencimento = true;

  int diaVencimento = 10;
  final TextEditingController taxaAtraso = TextEditingController(text: "2");
  final TextEditingController jurosDiario = TextEditingController(text: "0.033");

  final TextEditingController empresaNome = TextEditingController(text: "CONIM Gestão Imobiliária");
  final TextEditingController empresaCnpj = TextEditingController(text: "00.000.000/0000-00");
  final TextEditingController empresaCreci = TextEditingController(text: "12345-F");
  final TextEditingController empresaEndereco = TextEditingController(text: "Rua Exemplo, 123 - São Paulo, SP");
  final TextEditingController empresaTelefone = TextEditingController(text: "(11) 3000-0000");
  final TextEditingController empresaEmail = TextEditingController(text: "contato@conim.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Configurações"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard(
              title: "Preferências Gerais",
              description: "Configure as preferências básicas do sistema",
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: "Notificações por Email",
                    subtitle: "Receba alertas sobre pagamentos e contratos",
                    value: emailNotificacoes,
                    onChanged: (v) => setState(() => emailNotificacoes = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: "Modo Escuro",
                    subtitle: "Ativar tema escuro no sistema",
                    value: modoEscuro,
                    onChanged: (v) => setState(() => modoEscuro = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: "Alertas de Vencimento",
                    subtitle: "Notificar sobre contratos próximos ao vencimento",
                    value: alertasVencimento,
                    onChanged: (v) => setState(() => alertasVencimento = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Configurações de Pagamento",
              description: "Defina configurações padrão para pagamentos",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dia de Vencimento Padrão", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: diaVencimento,
                    decoration: _inputDecoration,
                    items: List.generate(
                      28,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text("Dia ${i + 1}"),
                      ),
                    ),
                    onChanged: (v) => setState(() => diaVencimento = v ?? 1),
                  ),

                  const SizedBox(height: 16),
                  _buildInput("Taxa de Atraso (%)", taxaAtraso),
                  const SizedBox(height: 16),
                  _buildInput("Juros Diário (%)", jurosDiario),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Informações da Empresa",
              description: "Dados que aparecem em contratos e documentos",
              child: Column(
                children: [
                  _buildInput("Nome da Empresa", empresaNome),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _buildInput("CNPJ", empresaCnpj)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInput("CRECI", empresaCreci)),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildInput("Endereço", empresaEndereco),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInput("Telefone", empresaTelefone)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInput("Email", empresaEmail)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Configurações salvas!")),
                      );
                    },
                    child: const Text("Salvar Configurações"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(description, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration.copyWith(labelText: label),
    );
  }

  InputDecoration get _inputDecoration {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}
