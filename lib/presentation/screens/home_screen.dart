import 'package:bloc_sample/presentation/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/counter_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key, required this.title, required this.color
  });


  final String title;
  final Color color;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        state.isIncremented ? "Increment" : "Decrement"),
                      duration: Duration(milliseconds: 1000),)
                );
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).decrement();
                        },
                        tooltip: "Decrement",
                        child: Icon(Icons.remove)

                    ),
                    Text("Counter: ${state.counter}"),
                    FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).increment();
                        },
                        tooltip: "Increment",
                        child: Icon(Icons.add)

                    )
                  ],
                );
              },
            ),
            MaterialButton(
              color: widget.color,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>
                        BlocProvider.value(
                          value: BlocProvider.of<CounterCubit>(context),
                          child: SecondScreen(
                            title: 'Second Screen',
                            color: Colors.redAccent,
                          ),
                        )
                    )
                );
              },
              child: Text("Go to next screen"),

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}