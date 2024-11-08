// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle_pedido_producto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetallePedidoProducto _$DetallePedidoProductoFromJson(
        Map<String, dynamic> json) =>
    DetallePedidoProducto(
      detallePedido:
          DetallePedido.fromJson(json['detallePedido'] as Map<String, dynamic>),
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetallePedidoProductoToJson(
        DetallePedidoProducto instance) =>
    <String, dynamic>{
      'detallePedido': instance.detallePedido,
      'producto': instance.producto,
    };
