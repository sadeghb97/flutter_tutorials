class SingletoneObject {
  static final SingletoneObject _singleton = new SingletoneObject._internal();
  bool mainMenuPushReplacement;

  //har bar ke az singleton shey sakhte shavad ejra mishavad
  //keyworde factory baraye in ast ke constructor betavanad meghdar return konad
  factory SingletoneObject() {
    return _singleton;
  }

  //faghat vaghti baraye avalin bar az singleton shey sakhte shavad ejra mishavad
  SingletoneObject._internal() {
    mainMenuPushReplacement = false;
  }
}