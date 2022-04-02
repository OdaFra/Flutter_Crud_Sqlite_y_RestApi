import 'package:devmobiletest/src/pages/homeapi.dart';
import 'package:devmobiletest/src/services/sqlite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _persona = [];

  bool _cargando = true;
  String _fecha = '';

  void _resfrescardata() async {
    final data = await CRUDSQLITE.obtenerPesona();
    setState(() {
      _persona = data;
      _cargando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _resfrescardata();
  }

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  TextEditingController _fechaController = new TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final personaexistente =
          _persona.firstWhere((element) => element['id'] == id);
      _nombreController.text = personaexistente['nombre'];
      _fechaController.text = personaexistente['fechaNac'];
      _sexoController.text = personaexistente['sexo'].toString();
    } else {
      _nombreController.text = '';
      _fechaController.text = '';
      _sexoController.text = '';
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _crearFecha(context),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _sexoController,
                    maxLength: 1,
                    decoration: const InputDecoration(
                        hintText: 'F o M',
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addPersona();
                      }

                      if (id != null) {
                        await _updatepersona(id);
                      }
                      _nombreController.text = '';
                      _fechaController.text = '';
                      _sexoController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Crear' : 'Actualizar'),
                  )
                ],
              ),
            ));
  }

//Para agregar Persona
  Future<void> _addPersona() async {
    await CRUDSQLITE.crearPersona(
        _nombreController.text, _fechaController.text, _sexoController.text);
    _resfrescardata();
  }

// Para actualizar Persona
  Future<void> _updatepersona(int id) async {
    await CRUDSQLITE.actualizarPersona(id, _nombreController.text,
        _fechaController.text, _sexoController.text);
    _resfrescardata();
  }

//Para eliminar Persona
  void _deletePersona(int id) async {
    await CRUDSQLITE.deletePersona(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se ha eliminado datos de una persona!'),
    ));
    _resfrescardata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Dev Mobile"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetalleApiPage()));
              },
              icon: Icon(Icons.api_rounded))
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _persona.length,
              itemBuilder: (context, index) => Card(
                color: Colors.blue.shade500,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _persona[index]['nombre'].toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _persona[index]['fechaNac'].toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text("Sexo :",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _persona[index]['sexo'].toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_persona[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deletePersona(_persona[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      controller: _fechaController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Fecha de nacimiento',
        labelText: 'Fecha de nacimiento',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext Context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _fecha = '${picked.day}-${picked.month}-${picked.year}';
        _fechaController.text = _fecha;
      });
    }
  }
}
