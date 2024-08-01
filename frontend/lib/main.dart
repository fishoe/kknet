import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter_rating/flutter_rating.dart';

void main() {
  runApp(const Kongkongnet());
}

class IceCream {
  final String id;
  final String name;
  final String category;
  final String image;

  IceCream(this.id, this.name, this.category, this.image);
}

class Review {
  final String id;
  final String iceCreamId;
  final int rating;
  final String comment;

  Review(this.id, this.iceCreamId, this.rating, this.comment);
}

class Deal {
  final String id;
  final String iceCreamId;
  final String comment;

  Deal(this.id, this.iceCreamId, this.comment);
}

class Kongkongnet extends StatelessWidget {
  const Kongkongnet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: '꽁꽁넷',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Main(title: '꽁꽁넷'),
          '/newPage': (context) => const NewPage(),
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  final String title;

  const Main({super.key, required this.title});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const SearchBar(),
            Expanded(
              child: appState.getCurrentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String? value = 'all';
  String? keyword;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Row(
      children: [
        DropdownButton(
          value: value,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('전체')),
            DropdownMenuItem(value: 'tube', child: Text('쭈쭈바')),
            DropdownMenuItem(value: 'stick', child: Text('스틱')),
            DropdownMenuItem(value: 'corn', child: Text('콘')),
            DropdownMenuItem(value: 'family', child: Text('패밀리')),
          ],
          onChanged: (String? value) {
            setState(() {
              this.value = value;
            });
          },
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: '검색어를 입력하세요',
            ),
            onChanged: (String value) {
              setState(() {
                keyword = value;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            appState.setCurrentKeyword(value, keyword);
          },
        ),
      ],
    );
  }
}

class IceCreamList extends StatefulWidget {
  const IceCreamList({super.key, this.keyword, this.category});

  final String? keyword;
  final String? category;

  @override
  State<IceCreamList> createState() => _IceCreamListState();
}

class _IceCreamListState extends State<IceCreamList> {
  List<String> iceCreams = [];

  @override
  void initState() {
    super.initState();
    iceCreams = [
      '바닐라',
      '코코아',
      '초콜릿',
      '딸기',
      '민트초코',
      '쿠키앤크림',
      '녹차',
      '망고',
      '블루베리',
      '요거트',
      '커피',
    ];
  }

  List<String> filterIceCreams() {
    if (widget.keyword == null || widget.keyword == '') {
      return iceCreams;
    } else {
      return iceCreams
          .where((element) => element.contains(widget.keyword!))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var filteredIceCreams = filterIceCreams();
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(filteredIceCreams.length, (index) {
        return GestureDetector(
          onTap: () {
            appState.createIceCreamDetailWidget(filteredIceCreams[index]);
          },
          child: Card(
            child: Center(
              child: Column(
                children: [
                  Image.network('https://picsum.photos/200'),
                  Text(filteredIceCreams[index]),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 페이지'),
      ),
      body: const Center(
        child: Text('이것은 새로운 페이지입니다.'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var iceCreamListWidget = IceCreamList();
  Widget? iceCreamDetailWidget;
  String? current_keyword;
  String? current_category;

  void setCurrentKeyword(String? category, String? keyword) {
    current_keyword = keyword;
    current_category = category;
    iceCreamDetailWidget = null;
    iceCreamListWidget = IceCreamList(keyword: keyword, category: category);
    notifyListeners();
  }

  Widget getCurrentWidget() {
    if (iceCreamDetailWidget != null) {
      return iceCreamDetailWidget!;
    } else {
      return iceCreamListWidget;
    }
  }

  void deleteIceCreamDetailWidget() {
    iceCreamDetailWidget = null;
    notifyListeners();
  }

  Widget createIceCreamDetailWidget(String iceCream) {
    iceCreamDetailWidget =
        iceCreamDetailWidget ?? IceCreamDetail(iceCream: iceCream);
    notifyListeners();
    return iceCreamDetailWidget!;
  }
}

class IceCreamDetail extends StatelessWidget {
  final String iceCream;

  const IceCreamDetail({super.key, required this.iceCream});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(iceCream),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              appState.deleteIceCreamDetailWidget();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.network('https://picsum.photos/200'),
            Text(iceCream),
            Expanded(
              child: DynamicTabBarWidget(
                onTabControllerUpdated: (p0) => {},
                isScrollable: false,
                dynamicTabs: [
                  TabData(
                    index: 1,
                    title: const Tab(
                      child: Text('리뷰'),
                    ),
                    content: const Center(child: IceCreamReview()),
                  ),
                  TabData(
                    index: 2,
                    title: const Tab(
                      child: Text('정보'),
                    ),
                    content: const Center(child: IceCreamDeal()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IceCreamReview extends StatefulWidget {
  const IceCreamReview({super.key});

  @override
  State<IceCreamReview> createState() => _IceCreamReviewState();
}

class _IceCreamReviewState extends State<IceCreamReview> {
  var reviews = [];

  var rating = 5.0;
  var comment = '';
  var password = '';

  @override
  void initState() {
    super.initState();
    reviews = [
      Review('1', '1', 5, '맛있어요'),
      Review('2', '1', 4, '괜찮아요'),
      Review('3', '1', 3, '별로에요'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: StarRating(
                onRatingChanged: (rating) => setState(() {
                  this.rating = rating;
                }),
                size: 30.0,
                rating: this.rating,
                color: Colors.orange,
                borderColor: Colors.grey,
                starCount: 5,
              ),
            ),
            Flexible(
              flex: 2,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '리뷰를 입력하세요',
                ),
                onChanged: (String value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력하세요.',
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    reviews.add(comment);
                  });
                },
                child: Text('등록')),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: StarRating(
                            size: 20.0,
                            rating: reviews[index].rating.toDouble(),
                            color: Colors.orange,
                            borderColor: Colors.grey,
                            starCount: 5,
                          ),
                        ),
                        Expanded(flex: 2, child: Text(reviews[index].comment)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Review'),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter password',
                                      ),
                                      onChanged: (String value) {
                                        // Handle password input
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle cancel button
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle delete button
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class IceCreamDeal extends StatefulWidget {
  const IceCreamDeal({super.key});

  @override
  State<IceCreamDeal> createState() => _IceCreamDealState();
}

class _IceCreamDealState extends State<IceCreamDeal> {
  List<Deal> deals = [];
  var comment = '';
  var password = '';

  @override
  void initState() {
    super.initState();
    deals = [
      Deal('1', '1', '오늘만 1+1'),
      Deal('2', '1', '무료배송'),
      Deal('3', '1', '10% 할인'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 3,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '정보를 입력하세요',
                ),
                onChanged: (String value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력하세요.',
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('등록')),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: deals.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: Text(deals[index].comment)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Review'),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter password',
                                      ),
                                      onChanged: (String value) {
                                        // Handle password input
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle cancel button
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle delete button
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
