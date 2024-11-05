// lib/view/screens/aprobacionClientes.dart
import 'package:flutter/material.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/main.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class AprobacionClientesPage extends StatefulWidget {
  const AprobacionClientesPage({Key? key}) : super(key: key);

  @override
  _AprobacionClientesPageState createState() => _AprobacionClientesPageState();
}

class _AprobacionClientesPageState extends State<AprobacionClientesPage> {
  final _dataService = getIt.get<DataService>();
  List<Cliente> _clientesPendientes = [];
  bool _isLoading = false;

  // Colores personalizados
  final Color primaryColor = Color(0xFF4B2C20); // Marrón
  final Color accentColor = Color(0xFFD2B48C); // Canela
  final Color backgroundColor = Color(0xFFF5F5F5); // Gris claro
  final Color textColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    _fetchPendingClientes();
  }

  Future<void> _fetchPendingClientes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Cliente> clientes = await _dataService.fetchPendingClientes();
      setState(() {
        _clientesPendientes = clientes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al obtener los clientes pendientes: ${e.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _approveCliente(Cliente cliente) async {
    try {
      await _dataService.updateClienteEstado(cliente.id, 'aprobado');
      setState(() {
        _clientesPendientes.remove(cliente);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cliente ${cliente.nombre} aprobado',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al aprobar el cliente: ${e.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectCliente(Cliente cliente) async {
    try {
      await _dataService.updateClienteEstado(cliente.id, 'rechazado');
      setState(() {
        _clientesPendientes.remove(cliente);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cliente ${cliente.nombre} rechazado',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al rechazar el cliente: ${e.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildClienteItem(Cliente cliente) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              cliente.fotoUrl != null ? NetworkImage(cliente.fotoUrl!) : null,
          backgroundColor: accentColor,
          child: cliente.fotoUrl == null
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                )
              : null,
        ),
        title: Text(
          '${cliente.nombre} ${cliente.apellido}',
          style: TextStyle(color: textColor),
        ),
        subtitle: Text(
          'DNI: ${cliente.dni}',
          style: TextStyle(color: textColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _approveCliente(cliente),
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _rejectCliente(cliente),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Aprobación de Clientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _clientesPendientes.isEmpty
              ? Center(
                  child: Text(
                    'No hay clientes pendientes de aprobación',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPendingClientes,
                  child: ListView.builder(
                    itemCount: _clientesPendientes.length,
                    itemBuilder: (context, index) {
                      Cliente cliente = _clientesPendientes[index];
                      return _buildClienteItem(cliente);
                    },
                  ),
                ),
    );
  }
}
