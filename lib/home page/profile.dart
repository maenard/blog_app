import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                spacing(20, 0),
                userInfo(
                  'John Doe',
                  'JDoe@gmail.com',
                  'assets/images/photo_male_7.jpg',
                ),
                // spacing(20, 0),
                // userStat(),
                spacing(20, 0),
                userAbout(),
                userPost(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  userPost() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Posts',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.white,
                    indent: 10,
                  ),
                ),
              ],
            ),
            spacing(10, 0),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/photo_male_7.jpg',
                  ),
                  radius: 15,
                ),
                spacing(0, 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Posted on: January 1, 2022',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        height: 0.8,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                      "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."),
                ),
              ],
            ),
          ],
        ),
      );

  userAbout() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.white,
                    indent: 10,
                  ),
                ),
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person_outline_rounded,
                ),
              ),
              title: Text(
                'John Doe',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Full Name',
                style: GoogleFonts.poppins(),
              ),
              horizontalTitleGap: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.alternate_email,
                ),
              ),
              title: Text(
                '@jDoeWrites',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Username',
                style: GoogleFonts.poppins(),
              ),
              horizontalTitleGap: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.mail_outline_rounded,
                ),
              ),
              title: Text(
                'JDoe@gmail.com',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Email',
                style: GoogleFonts.poppins(),
              ),
              horizontalTitleGap: 10,
            ),
          ],
        ),
      );

  userStat() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '50',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Following',
                style: GoogleFonts.poppins(
                  height: 0.8,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '100',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Posts',
                style: GoogleFonts.poppins(
                  height: 0.8,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '200k',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Followers',
                style: GoogleFonts.poppins(
                  height: 0.8,
                ),
              ),
            ],
          ),
        ],
      );

  spacing(
    double h,
    double w,
  ) =>
      SizedBox(
        height: h,
        width: w,
      );

  userInfo(String name, String email, String loc) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              loc,
            ),
            radius: 60,
          ),
          spacing(10, 0),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              height: 0.9,
            ),
          ),
          Text(
            email,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 15,
              height: 0.9,
            ),
          ),
        ],
      );

  customAppBar() => AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      );
}
