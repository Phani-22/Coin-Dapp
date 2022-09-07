import 'package:first_coin/serivce.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirstCoinService service;
  int coinValue = 0;

  @override
  void initState() {
    super.initState();
    service = FirstCoinService();
    service.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$coinValue",
          style: const TextStyle(fontSize: 40),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                service.incrementer();
                setState(() {
                  coinValue = service.counterValue;
                });
              },
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "INCREMENTER",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  service.coinGetter();
                  setState(() {
                    coinValue = service.counterValue;
                  });
                },
                child: const Text(
                  "GET COIN",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
              onPressed: () {
                service.decrementer();
                setState(() {
                  coinValue = service.counterValue;
                });
              },
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "DECREMENTER",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
