// Contains all the upload product page and logic
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/main.dart';
import 'package:olx_iit_ropar/src/screens/upload_result_screen.dart';
import 'package:olx_iit_ropar/src/widgets/dropdown.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'dropdown.dart';
import 'dart:async';
import 'package:image_pickers/image_pickers.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:provider/provider.dart';
import 'package:olx_iit_ropar/src/screens/my_html_editor_screen.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:http/http.dart' as http;

class UploadProductForm extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var product, category;
  UploadProductForm({Key? key, this.product, this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UploadProductFormState();
  }
}

class _UploadProductFormState extends State<UploadProductForm> {
  var _productType = '';
  var _price = 0;
  var _productTitle = '';
  var _productDescription = '';
  List<Media> images = <Media>[];
  List<Image> displayImages = <Image>[];
  var _dropDownValue = 'Others';
  bool isButtonDisabled = false;
  bool checkedValue = false;
  var _sellingReason = 'NA';
  var _timeUsed = '';
  var _brand = 'NA';
  bool? _status;
  var once = true;

  CategoryProvider categoryProvider = CategoryProvider();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get controller => null;

  changeProductType(String type) {
    setState(() {
      _dropDownValue = type;
    });
  }

  changeProductDescription(String val) {
    setState(() {
      _productDescription = val;
    });
  }

  Widget _buildPriceType() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Price in Rupees*'),
      initialValue: _price.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return 'Price is required';
        }
        _price = int.parse(value.toString());
        return null;
      },
    );
  }

  Widget _buildProductType() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: 'Product Type (If not in above list)'),
      maxLength: 100,
      initialValue: _productType,
      validator: (String? value) {
        _productType = value.toString();
        return null;
      },
    );
  }

  Widget _buildProductTitle() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Product Title*'),
      maxLength: 200,
      initialValue: _productTitle,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          _productTitle = value.toString();
          return 'Product title is required';
        }
        _productTitle = value.toString();
        return null;
      },
    );
  }

  Widget _buildNegotiationbox() {
    return CheckboxListTile(
      title: const Text(
        "Are you open to negotiation?",
        style: TextStyle(fontSize: 18),
      ),
      value: checkedValue,
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            checkedValue = newValue;
          });
        }
      },
      controlAffinity:
          ListTileControlAffinity.trailing, //  <-- leading Checkbox
    );
  }

  Widget _buildTimeSelectbox() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: 'Time Used* (format: Years-Months-Days)'),
      initialValue: _timeUsed,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          _timeUsed = '';
          return 'Time used is required';
        }
        RegExp exp = RegExp(r"^[0-9]+-[0-9]+-[0-9]+$");
        if (exp.hasMatch(value!) == false) {
          _timeUsed = '';
          return 'Please write in correct format';
        }
        _timeUsed = value;
        return null;
      },
    );
  }

  Widget _reasonForSelling() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Reason for Selling'),
      maxLength: 500,
      initialValue: _sellingReason,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          _sellingReason = 'NA';
        } else {
          _sellingReason = value.toString();
        }
        return null;
      },
    );
  }

  Widget _buildBrandType() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Product Brand'),
      maxLength: 100,
      initialValue: _brand,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          _brand = 'NA';
        } else {
          _brand = value.toString();
        }
        return null;
      },
    );
  }

  Future<void> pickImages() async {
    List<Media> resultList = <Media>[];
    String error = 'No Error Detected';
    try {
      resultList = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 3,
          showGif: false,
          showCamera: true,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: const Color(0xffff0f50)),
          cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future<bool?> onAdd() async {
    setState(() {
      isButtonDisabled = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    print(user!.email);

    var username = user.email!.substring(0, user.email!.length - 13);
    int categorykey = 0;

    categoryProvider.categories.forEach((key, value) {
      if (value.name == _dropDownValue) {
        categorykey = key;
      }
    });

    final Product prod = Product(
      title: _productTitle,
      category_id: categorykey,
      description: _productDescription,
      price: _price,
      username: username,
      brand: _brand,
      time_used: _timeUsed,
      negotiation_status: checkedValue,
      selling_reason: _sellingReason,
    );
    String? productId;
    if (widget.product == null) {
      productId = await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(prod);
    } else {
      prod.id = widget.product.id;
      productId = await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(prod);
    }

    if (productId == null) {
      setState(() {
        images = [];
        _productDescription = '';
      });
      setState(() {
        isButtonDisabled = false;
      });
      setState(() {
        _status = false;
      });
      return _status;
    }
    for (Media im in images) {
      File f = File(im.path!);
      Picture pic = Picture(
          image: im.path!, product_id: productId, category_id: categorykey);
      await Provider.of<PictureProvider>(context, listen: false)
          .addPicture(pic);
    }
    setState(() {
      images = [];
      _productDescription = '';
    });
    setState(() {
      isButtonDisabled = false;
    });
    setState(() {
      _status = true;
    });
  }

  Widget html() {
    return Html(
      data: _productDescription,
      //Optional parameters:
      onLinkTap: (url) {
        // open url in a webview
      },
      onImageTap: (src) {
        // Display the image in large form.
      },
    );
  }

  changeValues() {
    if (widget.product != null) {
      setState(() {
        _dropDownValue = widget.category;
        _productDescription = widget.product.description;
        _price = widget.product.price;
        _productTitle = widget.product.title;
        _timeUsed = widget.product.time_used;
        _sellingReason = widget.product.selling_reason.toString();
        _brand = widget.product.brand.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (once) {
      changeValues();
    }

    setState(() {
      once = false;
    });

    setState(() {
      categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    });

    List<String> dropdown = [];
    categoryProvider.categories.forEach((key, value) {
      dropdown.add(value.name);
    });

    return Expanded(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "All the star(*) marked fields are compulsory",
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: _status == null ? 0 : 5,
              ),
              Text(
                _status == null
                    ? ''
                    : _status!
                        ? 'Product successfully uploaded'
                        : 'Product upload failed',
                style: TextStyle(
                  fontSize: _status == null ? 0 : 13,
                  color: _status == null || _status == true
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 60.0,
                width: double.infinity,
                child: Dropdown(
                    _dropDownValue,
                    [
                      ...categoryProvider.categories.values
                          .map((e) => e.name)
                          .toList()
                    ],
                    changeProductType),
              ),
              const SizedBox(
                height: 15.0,
              ),
              _buildProductType(),
              _buildBrandType(),
              _buildProductTitle(),
              _buildTimeSelectbox(),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                height: 40.0,
                minWidth: 350,
                color: const Color(0xfff2f2f2),
                splashColor: Colors.grey,
                child: const Text(
                  'Write product description*',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HtmlEditorScreen(
                            changeProductDescription, _productDescription)),
                  );
                },
              ),
              SingleChildScrollView(
                child: Container(
                  // height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: html(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildPriceType(),
              const SizedBox(
                height: 15,
              ),
              _reasonForSelling(),
              const SizedBox(
                height: 15,
              ),
              _buildNegotiationbox(),
              const SizedBox(
                height: 20.0,
              ),
              widget.product == null
                  ? MaterialButton(
                      height: 40.0,
                      minWidth: 350,
                      color: const Color(0xfff2f2f2),
                      splashColor: Colors.grey,
                      child: const Text(
                        'Upload Images*',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: pickImages,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  for (Media im in images)
                    Image.file(
                      File(im.path!),
                      width: 100,
                      height: 90,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: isButtonDisabled
                        ? const Color.fromARGB(180, 0, 53, 49)
                        : myColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      _status = _formKey.currentState?.validate();
                    });

                    if ((images.isEmpty && widget.product == null) ||
                        _productDescription.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadResultScreen(
                            success: false,
                            isEdited: widget.product != null ? true : false,
                          ),
                        ),
                      );
                      return;
                    }
                    _formKey.currentState?.save();
                    isButtonDisabled ? null : await onAdd();
                    _formKey.currentState?.reset();
                    _status == true
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadResultScreen(
                                      success: true,
                                      isEdited:
                                          widget.product != null ? true : false,
                                    )),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadResultScreen(
                                success: false,
                                isEdited: widget.product != null ? true : false,
                              ),
                            ),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
