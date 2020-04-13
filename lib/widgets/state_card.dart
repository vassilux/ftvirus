import 'package:ftvirus/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_screen/responsive_screen.dart';

class StateSituationCard extends StatelessWidget {
  final String cardTitle;
  final String caseTitle;
  final int stateNumber;

  final Color cardColor;

  const StateSituationCard(
      {Key key,
      @required this.cardTitle,
      @required this.caseTitle,
      @required this.stateNumber,      
      this.cardColor = Palette.ftvColorBlue, 
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###", "eu");    
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Stack(
      children: <Widget>[
        Container(
 
          child: Column(
            children: <Widget>[
              Container(               
                margin: EdgeInsets.symmetric(horizontal:5, vertical: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 20,
                        spreadRadius: 3.5,
                        offset: Offset(0, 13)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(                         
                          margin: EdgeInsets.all(1),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Palette.ftvColorTransparentBlack,
                              borderRadius: BorderRadius.circular(5)),
                          child: RichText(
                            text: 
                                  TextSpan(
                                    text: "$cardTitle"
                                        .toUpperCase(),
                                    style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          
                                    ),
                                  )
                               
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                stateNumber != null
                                    ? formatter.format(stateNumber)
                                    : '-',
                                style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                ),
                              ),
                              
                              /*Text(
                                caseTitle ?? "",
                                style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                ),
                              ),*/
                            ],
                          ),
                          Spacer(),                         
                          
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        /*Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: <Widget>[
             
              Container(
                width: 25,
                height: 25,
                margin: EdgeInsets.all(25),                
              ),
            ],
          ),
        )*/
      ],
    );
  }
}