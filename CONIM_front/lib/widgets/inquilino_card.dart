import 'package:flutter/material.dart';

class InquilinoCard extends StatelessWidget {
  final Map<String, dynamic> inquilino;
  final VoidCallback? onEdit;

  const InquilinoCard({
    super.key,
    required this.inquilino,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit?.call();
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      inquilino["nome"] != null &&
                              (inquilino["nome"] as String).isNotEmpty
                          ? (inquilino["nome"] as String)
                              .substring(0, 1)
                              .toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  inquilino["nome"] ?? 'Sem nome',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),

                Text(
                  "CPF: ${inquilino["documento"] ?? 'Não informado'}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),

                if (inquilino["email"] != null)
                  Text(
                    inquilino["email"] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                const SizedBox(height: 4),
                if (inquilino["telefone"] != null)
                  Text(
                    inquilino["telefone"] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Renda: R\$ ${inquilino["rendaMensal"] ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}