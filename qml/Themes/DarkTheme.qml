import QtQuick 2.0

QtObject {
//    function themeSource(source) {
//        var s = '';
//        s = source;
//        if (s.indexOf('images/dark/') != -1)
//            return s.replace('images/dark/', 'images/')
//        return s;
//    }

    //====== Background colors:
    readonly property color backgroundGradColor1: "#13055A"
    readonly property color backgroundGradColor2: "#0A0028"
    readonly property color menuButtonBackgroundColor: "#1F115A"
    readonly property color menuButtonPressedBackgroundColor: "#3C3265"
    readonly property color menuButtonBorderColor: "#FFFFFF"
    readonly property color cellBorderColor: "#707070"

    readonly property color mainTextColor: "#FFFFFF"

    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.11
}
