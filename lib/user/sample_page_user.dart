import 'dart:async';
import 'dart:convert';

import 'package:abu_saxi_web/user/product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SamplePageUser extends StatefulWidget {
  const SamplePageUser({super.key});

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePageUser>
    with SingleTickerProviderStateMixin {
  late final _categoryNameController = TextEditingController();
  var category_name = [];
  var category_id = [];

  var isLoading = false;

  var userName = '';
  var userId = '';
  var userSurname = '';
  var userPhone = '';
  var userRole = '';
  var userStatus = '';
  var userBlocked = false;
  var userNames = '';
  var minWeight = '';
  var maxWeight = '';
  var minHeight = '';
  var maxHeight = '';

  Future<void> _getAllCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userid') ?? '';
    prefs.getString('name') ?? '';
    prefs.getString('surname') ?? '';
    prefs.getString('phone') ?? '';
    prefs.getString('username') ?? '';
    prefs.getString('role') ?? '';
    prefs.getString('userstatus') ?? '';
    prefs.getString('registerdate') ?? '';
    prefs.getBool('blocked') ?? false;
    userName = prefs.getString('name') ?? '';
    userId = prefs.getString('userid') ?? '';
    userSurname = prefs.getString('surname') ?? '';
    userPhone = prefs.getString('phone') ?? '';
    userRole = prefs.getString('role') ?? '';
    userStatus = prefs.getString('userstatus') ?? '';
    userBlocked = prefs.getBool('blocked') ?? false;
    userNames = prefs.getString('username') ?? '';

    final response = await http.get(Uri.parse(
        'https://abu-saxi-production.up.railway.app/getAllCategory'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['data'] == null) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategoriyalar mavjud emas'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (data['status'] == 'success') {
        category_name.clear();
        category_id.clear();
        isLoading = false;
        for (var i = 0; i < data['data'].length; i++) {
          category_name.add(data['data'][i]['category_name']);
          category_id.add(data['data'][i]['category_id']);
        }
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() {});
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('internetga ulanishni tekshiring!'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllCategory();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // here the desired height
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.4,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bo`limlar",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              const Expanded(
                child: SizedBox(),
              ),
              Text("Salom, $userName",
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.009,
              ),
              /*IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.white,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransaktionsPageUser(),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/userStatic.svg',
                  height: 30,
                  width: 30,
                  color: Colors.deepPurpleAccent,
                  //color: Colors.black,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.005,
              ),*/
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (category_name.isNotEmpty)
            Expanded(
              child: GridView.builder(
                itemCount: category_name.length,
                padding: const EdgeInsets.all(70),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPageUser(
                            category_id: category_id[index],
                            category_name: category_name[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox()),
                          AutoSizeText(
                            category_name[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.015,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxFontSize: 20,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (category_name.isEmpty)
            const Expanded(child: Center(
              child: Text("Bo`limlar mavjud emas yoki biroz kutib turing",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: const Color.fromRGBO(217, 217, 217, 100),
                onPressed: () {
                  isLoading = true;
                  setState(() {
                  });
                  _getAllCategory();
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text("Jami: ${category_name.length}",
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              if (isLoading)
                const CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
        ],
      ),
    );
  }
}
