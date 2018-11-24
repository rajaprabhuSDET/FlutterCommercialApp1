import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import '../widgets/helper/ensure-visible.dart';
import '../model/productinfo.dart';
import '../scopedmodel/mainmodel.dart';
import '../widgets/form_inputs/location.dart';
import '../model/location_data.dart';
import '../widgets/form_inputs/image.dart';

class CreateProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateProductState();
  }
}

class CreateProductState extends State<CreateProduct> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'imageURL': null,
    'location': null
  };
  final GlobalKey<FormState> _fieldState = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  Widget _buildProductTitleTextField(ProductInfo product) {
    if (product == null && _titleController.text.trim().isEmpty) {
      _titleController.text = '';
    } else if (product != null && _titleController.text.trim().isEmpty) {
      _titleController.text = product.title;
    } else if (product != null && _titleController.text.trim().isNotEmpty) {
      _titleController.text = _titleController.text;
    } else if (product == null && _titleController.text.trim().isNotEmpty) {
      _titleController.text = _titleController.text;
    } else {
      _titleController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        controller: _titleController,
        decoration: InputDecoration(labelText: 'Product Title'),
        //initialValue: product == null ? '' : product.title,
        onSaved: (String value) {
          _formData['title'] = value;
        },
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Field is required or should have 5+ characters';
          }
        },
      ),
    );
  }

  Widget _buildProductDescriptionTextField(ProductInfo product) {
    if (product == null && _descriptionController.text.trim().isEmpty) {
      _descriptionController.text = '';
    } else if (product != null && _descriptionController.text.trim().isEmpty) {
      _descriptionController.text = product.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Product Description'),
        controller: _descriptionController,
        onSaved: (String value) {
          _formData['description'] = value;
        },
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Field is required and should have 10+ characters';
          }
        },
      ),
    );
  }

  Widget _buildProductPriceTextField(ProductInfo product) {
    if (product == null && _priceController.text.trim().isEmpty) {
      _priceController.text = '';
    } else if (product != null && _priceController.text.trim().isEmpty) {
      _priceController.text = product.price.toString();
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        controller: _priceController,
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        //initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
            return 'Field is required';
          }
        },
      ),
    );
  }

  Widget _buildButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () => _actionOnPressed(
                    model.addGlass, model.updateGlass, model.selectProduct,
                    selectedProductIndex: model.selectedProductIndex),
              );
      },
    );
  }

  void _setLocation(LocationData locData) {
    _formData['location'] = locData;
  }

  void _setImage(File image) {
    _formData['imageURL'] = image;
  }

  void _actionOnPressed(
      Function addProduct, Function updateProduct, Function selectProduct,
      {int selectedProductIndex}) {
    if (!_fieldState.currentState.validate() ||
        (_formData['imageURL'] == null && selectedProductIndex == -1)) {
      return;
    }
    _fieldState.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _titleController.text,
        _descriptionController.text,
        _formData['imageURL'],
        double.parse(_priceController.text.replaceFirst(RegExp(r','), '.')),
        _formData['location'],
      ).then(
        (bool status) {
          if (status) {
            Navigator.pushReplacementNamed(context, '/home')
                .then((_) => selectProduct(null));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Something went Wrong!'),
                    content: Text('Please try again'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          }
        },
      );
    } else {
      updateProduct(
        _titleController.text,
        _descriptionController.text,
        _formData['imageURL'],
        double.parse(_descriptionController.text.replaceFirst(RegExp(r','), '.')),
        _formData['location'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/home')
          .then((_) => selectProduct(null)));
    }
  }

  Widget _buildPageContent(BuildContext context, ProductInfo product) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double customwidth = screenWidth > 550.0 ? 500.0 : screenWidth * 0.95;
    final double paddingwidth = screenWidth - customwidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _fieldState,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: paddingwidth / 2),
            children: <Widget>[
              _buildProductTitleTextField(product),
              _buildProductDescriptionTextField(product),
              _buildProductPriceTextField(product),
              SizedBox(height: 10.0),
              LocationInput(_setLocation, product),
              SizedBox(height: 10.0),
              ImageInput(_setImage, product),
              SizedBox(height: 10.0),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
