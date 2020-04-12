import 'dart:async';
import 'package:flutter/scheduler.dart';

import 'news_widget.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'news_bloc.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin {

  @override
  void didChangeDependencies() {
    
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      await Future.delayed(Duration(milliseconds: 200));
       BlocProvider.of<NewsBloc>(context).add(FetchNews());
    }); 
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    return SingleChildScrollView(child: BlocBuilder<NewsBloc, NewsState>(
        builder: (BuildContext context, NewsState state) {
      
      if (state is NewsLoaded) {
        return Container(
          height: hp(150),
          width: wp(150),
          child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              itemBuilder: (context, index) {
                return NewsWidget(
                  articleItem: state.news.articles[index],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: hp(1));
              },
              itemCount: state.news.articles.length),
        );
      }
      if (state is NewsLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            YMargin(hp(29)),
            Center(
                child: SpinKitSquareCircle(
              color: Palette.ftvColorBlue,
              size: 50.0,
            )),
          ],
        );
      }
      if (state is NewsError) {
        return Text(
          'Quelque chose a mal tourné!',
          style: TextStyle(color: Colors.red),
        );
      }

      return Center(
          child: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<NewsBloc>(context).add(FetchNews());
        },
        child: Icon(Icons.refresh),
        backgroundColor: Palette.ftvColorBlue,
      ));
    }));
  }

  @override
  bool get wantKeepAlive => true;
}
