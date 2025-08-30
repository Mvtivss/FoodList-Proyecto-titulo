// supermarket_product.dart

class SupermarketProduct {
  final String name;
  final String quantity;
  final double price;
  final String supermarket;

  SupermarketProduct({
    required this.name,
    required this.quantity,
    required this.price,
    required this.supermarket,
  });

  List<SupermarketProduct> getAvailableProducts() {
    return [
      // Productos para Lider Express
      SupermarketProduct(name: 'TUTO DE POLLO', quantity: '300gr', price: 1500, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'ARROZ', quantity: '1Kg', price: 1100, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'ACEITE DE OLIVA', quantity: '500ml', price: 5800, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'LECHE', quantity: '1L', price: 950, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'PAN', quantity: '500gr', price: 850, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'HUEVOS', quantity: '12 unidades', price: 1950, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'QUESO', quantity: '200gr', price: 2400, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'JAMÓN', quantity: '200gr', price: 2900, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'YOGUR', quantity: '1L', price: 2450, supermarket: 'Lider Express'),
      SupermarketProduct(name: 'CAFÉ', quantity: '250gr', price: 3800, supermarket: 'Lider Express'),

      // Productos para Unimarc
      SupermarketProduct(name: 'TUTO DE POLLO', quantity: '300gr', price: 1400, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'ARROZ', quantity: '1Kg', price: 1200, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'ACEITE DE OLIVA', quantity: '500ml', price: 8000, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'LECHE', quantity: '1L', price: 1000, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'PAN', quantity: '500gr', price: 900, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'HUEVOS', quantity: '12 unidades', price: 2000, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'QUESO', quantity: '200gr', price: 2500, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'JAMÓN', quantity: '200gr', price: 3000, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'YOGUR', quantity: '1L', price: 1500, supermarket: 'Unimarc'),
      SupermarketProduct(name: 'CAFÉ', quantity: '250gr', price: 3500, supermarket: 'Unimarc'),

      // Productos para Tottus
      SupermarketProduct(name: 'TUTO DE POLLO', quantity: '300gr', price: 1600, supermarket: 'Tottus'),
      SupermarketProduct(name: 'ARROZ', quantity: '1Kg', price: 1300, supermarket: 'Tottus'),
      SupermarketProduct(name: 'ACEITE DE OLIVA', quantity: '500ml', price: 8200, supermarket: 'Tottus'),
      SupermarketProduct(name: 'LECHE', quantity: '1L', price: 1050, supermarket: 'Tottus'),
      SupermarketProduct(name: 'PAN', quantity: '500gr', price: 550, supermarket: 'Tottus'),
      SupermarketProduct(name: 'HUEVOS', quantity: '12 unidades', price: 1700, supermarket: 'Tottus'),
      SupermarketProduct(name: 'QUESO', quantity: '200gr', price: 2600, supermarket: 'Tottus'),
      SupermarketProduct(name: 'JAMÓN', quantity: '200gr', price: 2100, supermarket: 'Tottus'),
      SupermarketProduct(name: 'YOGUR', quantity: '1L', price: 1550, supermarket: 'Tottus'),
      SupermarketProduct(name: 'CAFÉ', quantity: '250gr', price: 3600, supermarket: 'Tottus'),
    ];
  }
}