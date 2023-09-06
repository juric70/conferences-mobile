import 'dart:convert';
import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/city.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/network/city_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:conferences_mobile/network/autentification_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameContoller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController telephoneNumber = TextEditingController();
  TextEditingController roleIdController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  List<City> _city = [];
  int? selectedCity;
  bool isLoggedIn = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _telephoneNumberError;
  String? _addressError;
  String? _cityError;
  void _registration() async {
    try {
      int roleId = await AuthentificationService.getUserRoleId();
      String name = nameContoller.text;
      String email = emailController.text;
      String password = passwordController.text;
      String password_confirmation = passwordConfirmationController.text;
      String telNumb = telephoneNumber.text;
      String address = AddressController.text;
      final response = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
        'telephone_number': telNumb,
        'address': address,
        'city_id': selectedCity,
        'role_id': roleId
      };
      final jsonData = jsonEncode(response);
      String result =
          await AuthentificationService.registerUser(jsonData, context);
      if (result != '') {
        final Map<String, dynamic> errorData = jsonDecode(result);
        setState(() {
          _emailError = errorData['email'] != null
              ? errorData['email'][0].toString()
              : '';
          _nameError =
              errorData['name'] != null ? errorData['name'][0].toString() : '';
          _passwordError = errorData['password'] != null
              ? errorData['password'][0].toString()
              : '';
          _telephoneNumberError = errorData['telephone_number'] != null
              ? errorData['telephone_number'][0].toString()
              : '';
          _addressError =
              errorData['address'] != null ? errorData['address'][0] : '';
          _cityError =
              errorData['city_id'] != null ? errorData['city_id'][0] : '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged in successfully!'),
            backgroundColor: Color(0xff4a23b2),
          ),
        );
        Navigator.of(context).pushNamed('/');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCity();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    UserModel? user = await AuthModel().LoggedInUser();
    print(user);
    setState(() {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You are already loggedin!'),
              backgroundColor: Color(0xffbe2b61)),
        );
        Navigator.of(context).pushNamed('/');
      }
    });
  }

  _getCity() {
    CityService.getCity().then((city) {
      if (mounted) {
        setState(() {
          _city = city;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == false) {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            onDrawerIconPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyDrawer(
                    onDrawerIconPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },
            onBackIconPressed: () {
              Navigator.pop(context);
            },
            showBackIcon: false,
          ),
          body: SizedBox(
            child: Stack(
              children: [
                const BackgroundScrollView(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
                          child: Text(
                            'REGISTRATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: nameContoller,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              errorText: _nameError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: _emailError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: _passwordError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: passwordConfirmationController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password confirmation',
                              errorText: _passwordError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: telephoneNumber,
                            decoration: InputDecoration(
                              labelText: 'Telephone number',
                              errorText: _telephoneNumberError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextFormField(
                            controller: AddressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              errorText: _addressError,
                              labelStyle:
                                  const TextStyle(color: Color(0xffbe2b61)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff4a23b2), width: 1.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffeadc48),
                                  width: 0.50,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              fillColor: const Color(0xff1a1a1a),
                              filled: true,
                            ),
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: const Color(0XFF1A1A1A),
                            border: Border(
                              bottom: BorderSide(
                                color: _cityError == '' || _cityError == null
                                    ? const Color(0xff4a23b2)
                                    : Colors.red,
                              ),
                              top: BorderSide(
                                color: const Color(0xff4a23b2),
                                width: _cityError == '' || _cityError == null
                                    ? 2.0
                                    : 0.0,
                              ),
                              left: BorderSide(
                                color: const Color(0xff4a23b2),
                                width: _cityError == '' || _cityError == null
                                    ? 2.0
                                    : 0.0,
                              ),
                              right: BorderSide(
                                color: const Color(0xff4a23b2),
                                width: _cityError == '' || _cityError == null
                                    ? 2.0
                                    : 0.0,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: const Color(0xff1A1A1A),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int?>(
                                value: selectedCity,
                                hint: const Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                    'Odaberi grad ',
                                    style: TextStyle(
                                      color: Color((0xffbe2b61)),
                                    ),
                                  ),
                                ),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedCity = newValue!;
                                  });
                                },
                                items: _city
                                    .map<DropdownMenuItem<int?>>((City city) {
                                  return DropdownMenuItem<int?>(
                                    value: city.id,
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(
                                        color: Color(0xffbe2b61),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            _cityError ?? '',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'In case You already have an account ',
                            style: const TextStyle(
                              color: Color(0xffbe2b61),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: Color(0xffeadc48),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamed('/login');
                                    }),
                              const TextSpan(text: ' now!'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffbe2b61),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xffbb2a5f),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              _registration();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('processing data')),
                              );
                            },
                            child: const Text(
                              'Register!',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          onDrawerIconPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyDrawer(
                  onDrawerIconPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
          onBackIconPressed: () {
            Navigator.of(context).maybePop();
          },
          showBackIcon: true,
        ),
        body: const Stack(
          children: [
            BackgroundScrollView(),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
  }
}
