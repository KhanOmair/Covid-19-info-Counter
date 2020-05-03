import 'dart:convert';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tgd_covid_tracker/datasorce.dart';
import 'package:tgd_covid_tracker/pages/countyPage.dart';
import 'package:tgd_covid_tracker/pages/statePage.dart';
import 'package:tgd_covid_tracker/panels/indiapanel.dart';
import 'package:tgd_covid_tracker/panels/infoPanel.dart';
import 'package:tgd_covid_tracker/panels/mosteffectedcountries.dart';
import 'package:tgd_covid_tracker/panels/worldwidepanel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  //Todo: added this Function
  Map indiaData;
  fetchIndiaData() async {
    http.Response response = await http.get(
        'https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true');
    setState(() {
      indiaData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
    fetchCountryData();
    fetchIndiaData(); // added this
    print('fetchData called');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COVID-19 INFORMATION COUNTER',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white70, Colors.teal[100]
//                Color.fromRGBO(1, 72, 114, 100),
//                Color.fromRGBO(160, 234, 201, 100)
              ],
            ),
          ),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // WORLDWIDE INFO
                    Text(
                      'Worldwide',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: primaryBlack,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Countries',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? CircularProgressIndicator()
                  : WorldwidePanel(
                      worldData: worldData,
                    ),

              Center(
                child: SizedBox(
                  width: 250,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),

              // MOST AFFECTED INFO

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Most affected Countries',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              countryData == null
                  ? Container()
                  : MostAffectedPanel(
                      countryData: countryData,
                    ),

              Center(
                child: SizedBox(
                  width: 250,
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),

              // INDIA INFO
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      "https://corona.lmao.ninja/assets/img/flags/in.png",
                      height: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'India',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              indiaData == null
                  ? Container(child: Text('Not Retrieved'))
                  : IndiaPanel(
                      indiaData: indiaData,
                    ),

              //Button Panel

              SizedBox(
                height: 30,
              ),

              // Quote
              Center(
                  child: Text(
                'STAY INDOORS - STAY STRONG - STAY TOGETHER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
              SizedBox(
                height: 30,
              )
            ],
          )),
        ),
      ),
    );
  }
}
