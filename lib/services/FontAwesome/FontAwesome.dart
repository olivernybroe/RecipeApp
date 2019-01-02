
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fontAwesome;
import 'package:flutter/widgets.dart';

class FontAwesomeIcons extends fontAwesome.FontAwesomeIcons {
    // Turkey
    static const IconData turkeyLight = const IconDataLight(0xf725);
    static const IconData turkeySolid = const IconDataSolid(0xf725);
    static const IconData turkeyRegular = const IconDataRegular(0xf725);

    // Pie
    static const IconData pieLight = const IconDataLight(0xf705);
    static const IconData pieSolid = const IconDataSolid(0xf705);
    static const IconData pieRegular = const IconDataRegular(0xf705);

    // Apple Alt
    static const IconData appleAltLight = const IconDataLight(0xf5d1);
    static const IconData appleAltSolid = const IconDataSolid(0xf5d1);
    static const IconData appleAltRegular = const IconDataRegular(0xf5d1);
    
    // Wheat
    static const IconData wheatLight = const IconDataLight(0xf72d);
    static const IconData wheatSolid = const IconDataSolid(0xf72d);
    static const IconData wheatRegular = const IconDataRegular(0xf72d);    
    
    // Drumstick Bite
    static const IconData drumstickBiteLight = const IconDataLight(0xf6d7);
    static const IconData drumstickBiteSolid = const IconDataSolid(0xf6d7);
    static const IconData drumstickBiteRegular = const IconDataRegular(0xf6d7);
    
    // Utensils
    static const IconData utensilsLight = const IconDataLight(0xf2e7);
    static const IconData utensilsSolid = const IconDataSolid(0xf2e7);
    static const IconData utensilsRegular = const IconDataRegular(0xf2e7);
    
    // Birthday Cake
    static const IconData birthdayCakeLight = const IconDataLight(0xf1fd);
    static const IconData birthdayCakeSolid = const IconDataSolid(0xf1fd);
    static const IconData birthdayCakeRegular = const IconDataRegular(0xf1fd);



}

class IconDataLight extends IconData {
    const IconDataLight(int codePoint)
        : super(
        codePoint,
        fontFamily: 'FontAwesomeProLight',
    );
}

class IconDataSolid extends IconData {
    const IconDataSolid(int codePoint)
        : super(
        codePoint,
        fontFamily: 'FontAwesomeProSolid',
    );
}


class IconDataRegular extends IconData {
    const IconDataRegular(int codePoint)
        : super(
        codePoint,
        fontFamily: 'FontAwesomeProRegular',
    );
}

