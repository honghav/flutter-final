class Items{
  final String name;
  final double price;
  final int qty;

  const Items({
    required this.name,
    required this.price,
    required this.qty,
});
  
}

class OrderItems {
  final String name;
  final double price;
  final int qty;
  OrderItems({
    required this.name,
    required this.price,
    required this.qty,
  });

}

class Orders{
  String date;
  List<OrderItems> items;
  Orders({
    required this.date,
    required this.items
  });


}

