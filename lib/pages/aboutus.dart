import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            color: Colors.teal.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "This wonderful app is developed by the T.S.H team. We are on the mission to make things easy to access. No disturbing ads. We ask for Your support. Contact us at starhackerteam@gmail.com for support and enquiry.",
                style: TextStyle(
                  color: Colors.teal.shade600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                // Define the shape of the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // Define how the card's content should be clipped
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // Define the child widget of the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add padding around the row widget
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add an image widget to display an image
                          Image.asset(
                            "images/user1.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          // Add some spacing between the image and the text
                          Container(width: 20),
                          // Add an expanded widget to take up the remaining horizontal space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add some spacing between the top of the card and the title
                                Container(height: 5),
                                // Add a title widget
                                Text(
                                  "Harshit Pandey",
                                  style: TextStyle(color: Colors.teal.shade700),
                                ),
                                // Add some spacing between the title and the subtitle
                                Container(height: 20),
                                // Add a subtitle widget
                                Text(
                                  "Founder of T.S.H",
                                  style: TextStyle(color: Colors.teal.shade600),
                                ),
                                // Add some spacing between the subtitle and the text
                                Container(height: 10),
                                // Add a text widget to display some text
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                // Define the shape of the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // Define how the card's content should be clipped
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // Define the child widget of the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add padding around the row widget
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add an image widget to display an image
                          Image.asset(
                            "images/user2.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          // Add some spacing between the image and the text
                          Container(width: 20),
                          // Add an expanded widget to take up the remaining horizontal space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add some spacing between the top of the card and the title
                                Container(height: 5),
                                // Add a title widget
                                Text(
                                  "Pandit Ishika Kaushik",
                                  style: TextStyle(color: Colors.teal.shade700),
                                ),
                                // Add some spacing between the title and the subtitle
                                Container(height: 20),
                                // Add a subtitle widget
                                Text(
                                  "Co Founder of T.S.H",
                                  style: TextStyle(color: Colors.teal.shade600),
                                ),
                                // Add some spacing between the subtitle and the text
                                Container(height: 10),
                                // Add a text widget to display some text
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                // Define the shape of the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // Define how the card's content should be clipped
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // Define the child widget of the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add padding around the row widget
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add an image widget to display an image
                          Image.asset(
                            "images/user3.jpeg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          // Add some spacing between the image and the text
                          Container(width: 20),
                          // Add an expanded widget to take up the remaining horizontal space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add some spacing between the top of the card and the title
                                Container(height: 5),
                                // Add a title widget
                                Text(
                                  "Dhruv Pandey",
                                  style: TextStyle(color: Colors.teal.shade700),
                                ),
                                // Add some spacing between the title and the subtitle
                                Container(height: 20),
                                // Add a subtitle widget
                                Text(
                                  "CEO of T.S.H",
                                  style: TextStyle(color: Colors.teal.shade600),
                                ),
                                // Add some spacing between the subtitle and the text
                                Container(height: 10),
                                // Add a text widget to display some text
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  "images/banner1.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  "images/banner2.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
