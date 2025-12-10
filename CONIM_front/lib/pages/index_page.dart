// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'imoveis_page.dart';
import 'inquilinos_page.dart';
import 'configuracoes_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            collapsedHeight: 70,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              expandedTitleScale: 1.5,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0EA5E9),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo ao',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Contract Imóvel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Módulos do Sistema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildModulesGrid(context),

                  const SizedBox(height: 24),

                  _buildAlertsAndActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(BuildContext context) {
    final List<_Modulo> modulos = [
      _Modulo(
        nome: "Imóveis",
        icone: Icons.home_work_outlined,
        cor: const Color(0xFF3B82F6),
        descricao: "Gerencie seus imóveis",
        funcional: true,
      ),
      _Modulo(
        nome: "Inquilinos",
        icone: Icons.people_outline,
        cor: const Color(0xFF10B981),
        descricao: "Cadastro de clientes",
        funcional: true,
      ),
      _Modulo(
        nome: "Contratos",
        icone: Icons.description_outlined,
        cor: const Color(0xFF8B5CF6),
        descricao: "Contratos e documentos",
        funcional: false,
      ),
      _Modulo(
        nome: "Pagamentos",
        icone: Icons.payments_outlined,
        cor: const Color(0xFFF59E0B),
        descricao: "Controle financeiro",
        funcional: false,
      ),
      _Modulo(
        nome: "Relatórios",
        icone: Icons.bar_chart_outlined,
        cor: const Color(0xFFEF4444),
        descricao: "Análises e métricas",
        funcional: false,
      ),
      _Modulo(
        nome: "Configurações",
        icone: Icons.settings_outlined,
        cor: const Color(0xFF64748B),
        descricao: "Ajustes do sistema",
        funcional: true,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: modulos.length,
      itemBuilder: (context, index) {
        final modulo = modulos[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _navigateToModule(context, modulo),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: modulo.cor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: modulo.cor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            modulo.icone,
                            color: modulo.cor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          modulo.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          modulo.descricao,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        if (!modulo.funcional)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              'Em breve',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertsAndActivities() {
    final recentAlerts = [
      {
        'type': 'warning',
        'message': '3 pagamentos pendentes para hoje',
        'time': 'Agora',
      },
      {
        'type': 'info',
        'message': '2 contratos vencem em 15 dias',
        'time': 'Há 1 hora',
      },
      {
        'type': 'warning',
        'message': '1 imóvel necessita manutenção',
        'time': 'Há 3 horas',
      },
    ];

    final recentActivities = [
      {
        'type': 'contract',
        'message': 'Novo contrato cadastrado - Apt 301',
        'time': 'Há 2 horas',
      },
      {
        'type': 'payment',
        'message': 'Pagamento recebido - João Silva',
        'time': 'Há 5 horas',
      },
      {
        'type': 'property',
        'message': 'Imóvel atualizado - Casa Jardim Europa',
        'time': 'Há 1 dia',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: Colors.orange.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Alertas Recentes',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...recentAlerts.map((alert) => Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: alert['type'] == 'warning'
                                        ? Colors.orange.shade50
                                        : Colors.blue.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    alert['type'] == 'warning'
                                        ? Icons.warning_amber_outlined
                                        : Icons.info_outlined,
                                    size: 16,
                                    color: alert['type'] == 'warning'
                                        ? Colors.orange.shade600
                                        : Colors.blue.shade600,
                                  ),
                                ),
                                title: Text(
                                  alert['message'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  alert['time'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              if (recentAlerts.indexOf(alert) !=
                                  recentAlerts.length - 1)
                                Divider(
                                  height: 8,
                                  color: Colors.grey.shade200,
                                ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history_outlined,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Atividades Recentes',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...recentActivities.map((activity) => Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: activity['type'] == 'contract'
                                        ? Colors.green.shade500
                                        : activity['type'] == 'payment'
                                            ? Colors.blue.shade500
                                            : Colors.purple.shade500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                title: Text(
                                  activity['message'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  activity['time'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              if (recentActivities.indexOf(activity) !=
                                  recentActivities.length - 1)
                                Divider(
                                  height: 8,
                                  color: Colors.grey.shade200,
                                ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToModule(BuildContext context, _Modulo modulo) {
    if (modulo.nome == "Configurações") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ConfiguracoesPage()),
      );
    } 
    else if(modulo.nome == "Inquilinos") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InquilinosPage()),
      );
    }
    else if (modulo.funcional) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ImoveisPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${modulo.nome} ainda não implementado"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}

class _Modulo {
  final String nome;
  final IconData icone;
  final Color cor;
  final String descricao;
  final bool funcional;

  _Modulo({
    required this.nome,
    required this.icone,
    required this.cor,
    required this.descricao,
    this.funcional = false,
  });
}