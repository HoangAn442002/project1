import 'package:flutter/material.dart';

class Product {
  String name;
  String details;
  String productionDate;
  String imagePath; // Add imagePath property

  Product({
    required this.name,
    required this.details,
    required this.productionDate,
    required this.imagePath,
  });

  @override
  String toString() {
    return '$name';
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đặt hàng',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String searchKeyword = '';
  List<Product> items = [
    Product(
      name: "Sản phẩm 1",
      details: "Chi tiết sản phẩm 1",
      productionDate: "01/01/2023",
      imagePath: "assets/Sữa.jpg",
    ),
    Product(
      name: "Sản phẩm 2",
      details: "Chi tiết sản phẩm 2",
      productionDate: "02/01/2023",
      imagePath: "assets/product2.jpg",
    ),
    Product(
      name: "Sản phẩm 3",
      details: "Chi tiết sản phẩm 3",
      productionDate: "03/01/2023",
      imagePath: "assets/product3.jpg",
    ),
  ];
  List<Product> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        backgroundColor: Color(0xFFBE4D25),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  print("Sản phẩm trong giỏ hàng: $selectedItems");
                  _showSnackbar("Sản phẩm trong giỏ hàng: $selectedItems");
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    selectedItems.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.payment_outlined),
            onPressed: () {
              _navigateToPaymentScreen(context);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item.name.toLowerCase().contains(searchKeyword) ||
              item.details.toLowerCase().contains(searchKeyword)) {
            return ListTile(
              title: Text(item.name),
              subtitle: Text('Ngày sản xuất: ${item.productionDate}'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    selectedItems.add(item);
                  });
                },
              ),
              onTap: () {
                _showProductDetails(item);
              },
            );
          } else {
            return SizedBox.shrink(); // Ẩn sản phẩm không phù hợp
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Đã đặt hàng các sản phẩm: $selectedItems");
          _showSnackbar("Đã đặt hàng các sản phẩm: $selectedItems");
          setState(() {
            selectedItems.clear();
          });
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToPaymentScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen(selectedItems)),
    );
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                product.imagePath,
                width: 150,
                height: 150,
              ),
              Text('Chi tiết: ${product.details}'),
              Text('Ngày sản xuất: ${product.productionDate}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final List<Product> selectedItems;

  PaymentScreen(this.selectedItems);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        backgroundColor: Color.fromARGB(
            255, 141, 188, 241), // Set the app bar background color
      ),
      body: Container(
        color:
            Color.fromARGB(255, 111, 201, 231), // Set the body background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Danh sách sản phẩm cần thanh toán:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (var item in selectedItems)
                Text(
                  '- ${item.name}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showSnackbar(context, "Đã thanh toán thành công");
                },
                child: Text('Thanh toán'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
