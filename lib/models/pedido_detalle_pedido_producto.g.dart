// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido_detalle_pedido_producto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedidoDetallePedidoProducto _$PedidoDetallePedidoProductoFromJson(
        Map<String, dynamic> json) =>
    PedidoDetallePedidoProducto(
      pedido: Pedido.fromJson(json['pedido'] as Map<String, dynamic>),
      detallesPedidoProducto: (json['detallesPedidoProducto'] as List<dynamic>)
          .map((e) => DetallePedidoProducto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PedidoDetallePedidoProductoToJson(
        PedidoDetallePedidoProducto instance) =>
    <String, dynamic>{
      'pedido': instance.pedido,
      'detallesPedidoProducto': instance.detallesPedidoProducto,
    };
