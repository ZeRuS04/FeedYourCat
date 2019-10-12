import QtQuick 2.0

QtObject {
//    function themeSource(source) {
//        var s = '';
//        s = source;
//        if (s.indexOf('images/dark/') != -1)
//            return s.replace('images/dark/', 'images/')
//        return s;
//    }
    readonly property string catalogName: "Dark_Theme"

    //====== Background colors:
    readonly property color backgroundGradColor1: "#13055A"
    readonly property color backgroundGradColor2: "#0A0028"
    readonly property color menuButtonBackgroundColor: "#1F115A"
    readonly property color menuButtonPressedBackgroundColor: "#3C3265"
    readonly property color menuButtonBorderColor: "#FFFFFF"
//    readonly property color cellBorderColor: "#707070"
    readonly property color toolbarBackgroundColor: "#10034E"
    readonly property color cellBackgroundColor: "#1D1243"
    readonly property color cellBorderColor: "#8567A0"
    readonly property color themeSwitcherCheckedColor: "#FFFFFF"

    readonly property color mainTextColor: "#FFFFFF"
    readonly property color toolbarTextColor: "#ECC0E9"

    readonly property color alertColor: "#DC143C"
    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.11
    readonly property real cellBackgroundOpacity: 0.38
    readonly property real themeSwitcherOpacity: 0.15

    //====== Images:
    property url mainMenuImage: "qrc:/resources/images/cats/Start_Cats/SVG/Start_Cat_Dark_Theme.svg"
    property url scoreImage: "qrc:/resources/icons/Dark_Theme/cat_score.svg"
}
