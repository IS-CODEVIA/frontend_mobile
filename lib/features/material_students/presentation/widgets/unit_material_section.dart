import 'package:flutter/material.dart';
import '../../domain/models/material_model.dart';
import 'material_list_item.dart';

class UnitMaterialSection extends StatelessWidget {
  final UnitMaterialsModel unitModel;

  const UnitMaterialSection({super.key, required this.unitModel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          unitModel.unitName,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: colorScheme.secondary,
          thickness: 1.0,
          height: 16,
        ),
        if (unitModel.materials.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: unitModel.materials.length,
            itemBuilder: (context, index) {
              return MaterialListItem(
                item: unitModel.materials[index],
              );
            },
          ),
      ],
    );
  }
}