import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int currentIndex = 0;

 @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'All',
      'Zip Lining',
      'Rafting',
      'Hiking',
      'Paragliding',
      'Bungee'
    ];

    final List<Map<String, String>> adventures = [
      {'title': 'Rafting', 'image': 'assets/image/rafting.jpg'},
      {'title': 'Bungee jumping', 'image': 'assets/image/bungeejumping.jpg'},
      {'title': 'Sky diving', 'image': 'assets/image/skydiving.jpg'},
      {'title': 'Paragliding', 'image': 'assets/image/paragliding.jpg'},
      {'title': 'Hot Ballooning', 'image': 'assets/image/hotairballoning.jpg'},
      {'title': 'Zip Flyer', 'image': 'assets/image/zipflyer.jpg'},
    ];

    final List<Widget> _pages = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 4),
                Text("SHIP TO", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("Bhaktapur, Nepal", style: TextStyle(fontWeight: FontWeight.w500)),
                Spacer(),
                Icon(Icons.settings, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                text: 'Hey Akash, ',
                style: TextStyle(fontSize: 20),
                children: [
                  TextSpan(
                    text: 'Good Afternoon!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search for adventurous activities",
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("All Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text("See All")),
              ],
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Chip(
                    label: Text(categories[index]),
                    backgroundColor: index == 0 ? Colors.green.shade100 : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: index == 0 ? Colors.green : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children: adventures.map((item) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            )
          ],
        ),
      ),
      Center(child: Text('Explore Screen'),),
      Center(child: Text('Settings Screen'),),
      Center(child: Text('Profile Screen'),),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Thrill Quest",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 22,
          ),
        ),
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.grey[200],
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              setState(() {
                currentIndex = 0;
              });
            }, icon: Icon(Icons.home_sharp, color: currentIndex == 0 ? Colors.green : Colors.grey)),

            IconButton(onPressed: (){
              setState(() {
                currentIndex = 1;
              });
            }, icon: Icon(Icons.explore, color: currentIndex == 1 ? Colors.green : Colors.grey)),

            const SizedBox(width: 48,),

            IconButton(onPressed: (){
              setState(() {
                currentIndex = 2;
              });
            }, icon: Icon(Icons.settings, color: currentIndex == 2 ? Colors.green : Colors.grey )),

            IconButton(onPressed: (){
              setState(() => currentIndex = 3);
            }, icon: Icon(Icons.person, color: currentIndex == 3 ? Colors.green : Colors.grey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        heroTag: 'home_fab',
        onPressed: () {},
        shape: StadiumBorder(),
        child: const Icon(Icons.grid_view),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}