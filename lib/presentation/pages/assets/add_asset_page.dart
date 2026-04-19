import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../../logic/blocs/dashboard/dashboard_event.dart';
import '../../../domain/models/asset_model.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();

  // Crypto
  final _symbolController = TextEditingController();
  final _quantityController = TextEditingController();

  // Steam
  final _marketHashNameController = TextEditingController();

  // Physical
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  String _condition = 'Good';

  AssetType _selectedType = AssetType.crypto;

  static const _conditions = ['New', 'Like New', 'Good', 'Fair', 'Poor'];

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    _marketHashNameController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.addNewAsset,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(l10n.assetDetails),
              const SizedBox(height: 20),
              _buildCard(
                context: context,
                child: Column(
                  children: [
                    _buildTextField(
                      context: context,
                      label: l10n.assetName,
                      controller: _nameController,
                      icon: Icons.label_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTypeDropdown(context, l10n),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context: context,
                      label: l10n.initialValue,
                      controller: _valueController,
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.requiredField;
                        if (double.tryParse(v) == null) return l10n.invalidNumber;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Type-specific fields
              _buildTypeSpecificFields(context, l10n),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3192),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(l10n.addAsset,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSpecificFields(BuildContext context, AppLocalizations l10n) {
    switch (_selectedType) {
      case AssetType.crypto:
        return _buildCard(
          context: context,
          child: Column(
            children: [
              _buildTextField(
                context: context,
                label: 'Symbol (e.g. BTC, ETH)',
                controller: _symbolController,
                icon: Icons.currency_bitcoin,
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                label: 'Quantity',
                controller: _quantityController,
                icon: Icons.numbers,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.requiredField;
                  if (double.tryParse(v) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
            ],
          ),
        );

      case AssetType.inventory:
        return _buildCard(
          context: context,
          child: _buildTextField(
            context: context,
            label: 'Market Hash Name',
            controller: _marketHashNameController,
            icon: Icons.inventory_2_outlined,
            validator: (v) =>
                (v == null || v.isEmpty) ? l10n.requiredField : null,
          ),
        );

      case AssetType.collectible:
      case AssetType.stock:
      case AssetType.cash:
        return _buildCard(
          context: context,
          child: Column(
            children: [
              _buildTextField(
                context: context,
                label: 'Category',
                controller: _categoryController,
                icon: Icons.category_outlined,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                label: 'Brand',
                controller: _brandController,
                icon: Icons.store_outlined,
              ),
              const SizedBox(height: 20),
              _buildConditionDropdown(context),
            ],
          ),
        );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildCard({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF2E3192)),
            filled: true,
            fillColor: isDark ? Colors.white10 : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.assetType,
            style: const TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AssetType>(
              value: _selectedType,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF2E3192)),
              onChanged: (value) => setState(() => _selectedType = value!),
              items: AssetType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type.name[0].toUpperCase() + type.name.substring(1),
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Condition',
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _condition,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF2E3192)),
              onChanged: (value) => setState(() => _condition = value!),
              items: _conditions
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<DashboardBloc>().add(AddAsset(
            name: _nameController.text,
            type: _selectedType,
            initialValue: double.parse(_valueController.text),
            symbol: _symbolController.text.isEmpty
                ? null
                : _symbolController.text.toUpperCase(),
            quantity: double.tryParse(_quantityController.text),
            marketHashName: _marketHashNameController.text.isEmpty
                ? null
                : _marketHashNameController.text,
            category: _categoryController.text.isEmpty
                ? null
                : _categoryController.text,
            brand: _brandController.text.isEmpty
                ? null
                : _brandController.text,
            condition: _condition,
          ));
      context.pop();
    }
  }
}
