import 'package:bloc_sample/business_logic/cubits/counter_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.title}'),
      ),
      body: Center(
          child: BlocBuilder<CounterCubit, CounterState >(
            builder: (context, state) {
              return Text('${state.counter}');
            },
          )
      ),
    );
  }
}
