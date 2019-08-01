import 'package:flutter/material.dart';

LangIcon(String value) {
  if (value == 'eng') {
    return new Image(
      image: new AssetImage('images/united-kingdom.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'zho') {
    return new Image(
      image: new AssetImage('images/china.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'deu') {
    return new Image(
      image: new AssetImage('images/germany.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'fra') {
    return new Image(
      image: new AssetImage('images/france.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'rus') {
    return new Image(
      image: new AssetImage('images/russia.png'),
      width: 25,
      height: 25,
    );
  } else if (value == 'jpn') {
    return new Image(
      image: new AssetImage('images/japan.png'),
      width: 25,
      height: 25,
    );
  }
}
