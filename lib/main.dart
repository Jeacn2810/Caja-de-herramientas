import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToolboxPage(),
    );
  }
}

class ToolboxPage extends StatefulWidget {
  @override
  _ToolboxPageState createState() => _ToolboxPageState();
}

class _ToolboxPageState extends State<ToolboxPage> {
  String _name = '';
  String _gender = '';
  String _ageGroup = '';
  int _age = 0;
  bool _isLoading = false;
  List<dynamic> _universities = [];

  Future<void> _fetchGender(String name) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _gender = data['gender'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load gender');
    }
  }

  Future<void> _fetchAge(String name) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _age = data['age'];
        if (_age < 30) {
          _ageGroup = 'joven';
        } else if (_age < 60) {
          _ageGroup = 'adulto';
        } else {
          _ageGroup = 'anciano';
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load age');
    }
  }

  Future<void> _fetchUniversities(String countryName) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$countryName'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _universities = data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load universities');
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acerca de'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/julio.png'), 
              ),
              SizedBox(height: 10),
              Text(
                'Julio Emanuel Alberto Carrillo Nuñez 2021-0182', 
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTimBlog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimBlogPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja de Herramientas'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/toolbox.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '¡Bienvenido a la Caja de Herramientas!',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Nombre'),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _fetchGender(_name);
                        _fetchAge(_name);
                      },
                      child: Text('Obtener información'),
                    ),
                    SizedBox(height: 20),
                    _gender.isNotEmpty
                        ? Text(
                            _gender == 'male' ? 'Masculino' : 'Femenino',
                            style: TextStyle(fontSize: 20, color: _gender == 'male' ? Colors.blue : Colors.pink),
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    _ageGroup.isNotEmpty
                        ? Column(
                            children: [
                              Text(
                                'Edad: $_age',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Grupo de edad: $_ageGroup',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Image.asset(
                                _ageGroup == 'joven'
                                    ? 'assets/young.png'
                                    : _ageGroup == 'adulto'
                                        ? 'assets/adult.png'
                                        : 'assets/elderly.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'País'),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _fetchUniversities(_name);
                      },
                      child: Text('Mostrar universidades'),
                    ),
                    SizedBox(height: 20),
                    _universities.isNotEmpty
                        ? Column(
                            children: _universities.map((university) {
                              return ListTile(
                                title: Text(university['name']),
                                subtitle: Text(university['domains'][0]),
                                onTap: () {},
                              );
                            }).toList(),
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateToTimBlog,
                      child: Text('Ir al blog de Tim'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class TimBlogPage extends StatefulWidget {
  @override
  _TimBlogPageState createState() => _TimBlogPageState();
}

class _TimBlogPageState extends State<TimBlogPage> {
  // Variable para almacenar la respuesta de la API
  List<dynamic>? postData;

  // Método para realizar la solicitud HTTP a la API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://tim.blog/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      setState(() {
        postData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load post data');
    }
  }

  // Función para eliminar etiquetas HTML del contenido
  String _stripHtmlTags(String htmlContent) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlContent.replaceAll(exp, '');
  }

  // Función para abrir el enlace en el navegador
  void _launchURL() async {
    const url = 'https://tim.blog/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tim Blog'),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: _launchURL,
          ),
        ],
      ),
      body: postData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: postData!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_stripHtmlTags(postData![index]['title']['rendered'])),
                  subtitle: Text(_stripHtmlTags(postData![index]['content']['rendered'])),
                );
              },
            ),
    );
  }
}

