import 'package:flutter/material.dart';
import '../services/products_service.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;
  final String initialName;
  final double initialPrice;

  const EditProductScreen({
    Key? key,
    required this.productId,
    required this.initialName,
    required this.initialPrice,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isLoading = false;
  final _focusNodeName = FocusNode();
  final _focusNodePrice = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _priceController = TextEditingController(text: widget.initialPrice.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _focusNodeName.dispose();
    _focusNodePrice.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final String name = _nameController.text.trim();
    final priceString = _priceController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final double? price = double.tryParse(priceString);

    if (price == null) {
      _showSnackbar('Preço inválido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _productService.updateProduct(widget.productId, name, price);
      
      if (!mounted) return;
      
      if (success) {
        Navigator.pop(context, true);
      } else {
        _showSnackbar('Falha ao atualizar produto');
      }
    } catch (e) {
      _showSnackbar('Erro ao atualizar produto: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNodeName.unfocus();
        _focusNodePrice.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Editar Produto',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  focusNode: _focusNodeName,
                  decoration: InputDecoration(
                    labelText: 'Nome do Produto',
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Nome obrigatório' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  focusNode: _focusNodePrice,
                  decoration: InputDecoration(
                    labelText: 'Preço',
                    prefixIcon: Text('R\$ ', style: TextStyle(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Preço obrigatório';
                    }
                    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (cleanValue.isEmpty || double.tryParse(cleanValue) == null) {
                      return 'Preço inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[600]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'SALVAR ALTERAÇÕES',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}