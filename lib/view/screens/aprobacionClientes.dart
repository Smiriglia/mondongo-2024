// lib/view/screens/aprobacionClientes.dart
import 'package:flutter/material.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/main.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/services/email_service.dart';

@RoutePage()
class AprobacionClientesPage extends StatefulWidget {
  const AprobacionClientesPage({Key? key}) : super(key: key);

  @override
  _AprobacionClientesPageState createState() => _AprobacionClientesPageState();
}

class _AprobacionClientesPageState extends State<AprobacionClientesPage> {
  final _dataService = getIt.get<DataService>();
  final _emailService = getIt.get<EmailService>();
  List<Cliente> _clientesPendientes = [];
  bool _isLoading = false;

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
          backgroundColor: Color(0xFF4B2C20),
        ),
      );
      _emailService.sendEmail(
          cliente.email, 'Aprobación de Cuenta', 'Tu cuenta ha sido aprobada.');
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
          backgroundColor: Color(0xFF4B2C20),
        ),
      );
      _emailService.sendEmail(cliente.email, 'Aprobación de Cuenta',
          'Tu cuenta ha sido rechazada.');
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Color(0xFF5D4037).withOpacity(0.5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              cliente.fotoUrl != null ? NetworkImage(cliente.fotoUrl!) : null,
          backgroundColor: Color(0xFF5D4037),
          child: cliente.fotoUrl == null
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                )
              : null,
        ),
        title: Text(
          '${cliente.nombre} ${cliente.apellido}',
          style: TextStyle(
            color: Color(0xFF4B2C20),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'DNI: ${cliente.dni}',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        trailing: Wrap(
          spacing: 12, // espacio entre los botones
          children: [
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green, size: 28),
              tooltip: 'Aprobar',
              onPressed: () => _approveCliente(cliente),
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red, size: 28),
              tooltip: 'Rechazar',
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
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        title: Text(
          'Aprobación de Clientes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4B2C20),
        elevation: 4,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B2C20)),
              ),
            )
          : _clientesPendientes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay clientes',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 20), // Espaciado
                      Text(
                        'pendientes de aprobación.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPendingClientes,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
