import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/view/screenowner/AddBraceletsPage.dart';
import 'package:flutter_application_1/view/screenowner/AddEarringPage.dart';
import 'package:flutter_application_1/view/screenowner/AddSanasilPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view/screen/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BraceletsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 38,
        titleTextStyle: TextStyle(height: 2),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 30,
          color: Color.fromRGBO(228, 187, 5, 1),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            ' اساور',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.fromARGB(255, 235, 201, 26),
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 53, horizontal: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Bracelets').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Bracelets = snapshot.data!.docs;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set the number of columns in the grid
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: Bracelets.length,
                itemBuilder: (context, index) {
                  final Bracelet =
                      Bracelets[index].data() as Map<String, dynamic>;
                  return BraceletItem(
                    imageUrl: Bracelet['imageUrl'] as String?,
                    name: Bracelet['name'] as String,
                    price: Bracelet['price'] as double,
                    weight: Bracelet['weight'] as double,
                    carat: Bracelet['carat'] as double,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class BraceletItem extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double price;
  final double weight;
  final double carat;

  BraceletItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.weight,
    required this.carat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              imageUrl: imageUrl,
              name: name,
              price: price,
              weight: weight,
              carat: carat,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (imageUrl != null)
                Image.network(
                  imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String? imageUrl;
  final String name;

  final double price;
  final double weight;
  final double carat;

  ProductDetailsPage({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.weight,
    required this.carat,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double goldPrice21InDinar = 0.0;
  @override
  void initState() {
    super.initState();
    fetchGoldPrice21();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 38,
        titleTextStyle: TextStyle(height: 2),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 30,
          color: Color.fromRGBO(228, 187, 5, 1),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            ' التفاصيل',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.fromARGB(255, 235, 201, 26),
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 77),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.imageUrl != null)
                Image.network(widget.imageUrl!, width: 200, height: 200),
              SizedBox(height: 16),
              Text(
                widget.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'السعر: ${(goldPrice21InDinar + widget.price) * widget.weight} دينار',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'الوزن:  ${widget.weight}', // عرض الوزن هنا
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'العيار:  ${widget.carat}', // عرض العيار هنا
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 24),
              Container(
                width: 305,
                height: 57,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Color.fromARGB(255, 241, 213, 74),
                      shape: StadiumBorder()),
                  onPressed: () {
                    CartItem cartItem = CartItem(
                      name: widget.name,
                      imageUrl: widget.imageUrl ?? '',
                      price: widget.price,
                    );
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(cartItem);
                    Fluttertoast.showToast(
                      msg: 'تمت الإضافة إلى السلة بنجاح!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[600],
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Center(
                      child: Text(
                    ' اضافة الى السلة',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchGoldPrice21() async {
    final apiKey = 'aaed59d4de024da5fdb99f222f6b2f27';
    final apiUrl = 'https://api.metalpriceapi.com';
    final symbol = "XAU";
    final currency = "USD";
    final endpointUrl =
        '$apiUrl/v1/latest?api_key=$apiKey&base=$currency&currencies=$symbol';

    try {
      final response = await http.get(Uri.parse(endpointUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double exchangeRate = await getExchangeRate();
        double goldPricePerOunce =
            1 / double.parse(data['rates']['XAU'].toString());
        double goldPricePerGram = goldPricePerOunce / 31.1035;
        double goldPrice21 = goldPricePerGram * 0.875; // عيار 21
        double goldPrice21InDinar = goldPrice21 * exchangeRate;

        // تحويل الرقم إلى نص وتقليصه إلى 4 أرقام بعد الفاصلة العشرية
        String formattedPrice = goldPrice21InDinar.toStringAsFixed(2);

        setState(() {
          this.goldPrice21InDinar = double.parse(formattedPrice);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('خطأ'),
              content: Text('حدث خطأ أثناء جلب سعر الجرام عيار 21.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('حسنًا'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<double> getExchangeRate() async {
    final exchangeRateEndpoint =
        'https://api.exchangerate-api.com/v4/latest/USD';
    final response = await http.get(Uri.parse(exchangeRateEndpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rates']['JOD']; // الدينار الأردني
    } else {
      throw Exception('Failed to fetch exchange rate');
    }
  }
}
