import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/models/mesa.dart';

@RoutePage()
class MesaPage extends StatelessWidget {
  final Mesa mesa;
  const MesaPage({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('mesa-${mesa.numero}'),
      ),
    );
  }
}