
import 'package:flutter/material.dart';
import 'SliderPage.dart';

//import 'add_image.dart';

class Landing extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Landing> {
int _currentPage = 0;
  PageController _controller = PageController();


List<Widget> _pages = [
    SliderPage(
        title: "",
        description:
            "",
        image: 'asset/img/land1.svg'),
    SliderPage(
        title: "",
        description:
            "",
        image: 'asset/img/land2.svg'),
    SliderPage(
        title: "",
        description:
            "",
        image: 'asset/img/land3.svg'),
  ];
   _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

@override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onchanged,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, int index) {
              return _pages[index];
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_pages.length, (int index) {
                    return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.teal
                                : Colors.teal.withOpacity(0.5)));
                  })),
              InkWell(
                onTap: () {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint);
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 70,
                  width: (_currentPage == (_pages.length - 1)) ? 200 : 75,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(35)),
                  child: (_currentPage == (_pages.length - 1))
                      ? FlatButton(
                        shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(18.0),
                         side: BorderSide(color: Colors.teal)),
                         textColor: Colors.white,
                         color: Colors.teal,
                         child: Text("Get Started",
                          style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          Navigator.pushNamed(context, 'SignIn');
                        },
                         )
                      : Icon(
                          Icons.navigate_next,
                          size: 50,
                          color: Colors.white,
                        ),
                   
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}