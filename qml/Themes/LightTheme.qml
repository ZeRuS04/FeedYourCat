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
    readonly property color backgroundGradColor1: "#F5E1E7"
    readonly property color backgroundGradColor2: "#F1D0E0"
    readonly property color menuButtonBackgroundColor: "#F4E0E6"
    readonly property color menuButtonBorderColor: "#F4E0E6"
    readonly property color cellBorderColor: "#707070"

    readonly property color mainTextColor: "#000000"

    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.49
}
