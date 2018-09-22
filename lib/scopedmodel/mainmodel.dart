import 'package:scoped_model/scoped_model.dart';

import './connectedproducts.dart';

class MainModel extends Model with ConnectedProductsModel, ProductModel, UserModel {}
