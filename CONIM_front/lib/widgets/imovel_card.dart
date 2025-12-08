import 'package:flutter/material.dart';
import '../pages/imovel_form_page.dart';

class ImovelCard extends StatelessWidget {
  final Map<String, dynamic> imovel;
  final VoidCallback? onTap; // abrir detalhes
  final VoidCallback? onDelete; // ação de deletar
  final VoidCallback? onEdit; // ação de editar

  const ImovelCard({
    super.key,
    required this.imovel,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEM
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(imovel["imagem"] ??
                      "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=600"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão Editar
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: onEdit ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ImovelFormPage(imovel: imovel)),
                            ).then((value) {
                              if (value == true && onTap != null) onTap!();
                            });
                          },
                    ),
                    // Botão Excluir
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${imovel["cidade"]}, ${imovel["bairro"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${imovel["quartos"] ?? "-"} quartos • ${imovel["banheiros"] ?? "-"} banheiros • ${imovel["area"] ?? "-"} m²",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "R\$ ${imovel["valorAluguel"]?.toStringAsFixed(0) ?? "-"} / mês",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.green.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${imovel["statusImovel"] ?? "-"}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
