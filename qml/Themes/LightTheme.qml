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
    readonly property color menuButtonPressedBackgroundColor: "#AE6A80"
    readonly property color menuButtonBorderColor: "#000000"
    readonly property color cellBorderColor: "#707070"
    readonly property color toolbarBackgroundColor: "#E2B8C5"

    readonly property color mainTextColor: "#000000"
    readonly property color toolbarTextColor: "#28204A"

    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.49
}
