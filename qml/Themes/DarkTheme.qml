import QtQuick 2.0

QtObject {
    id: root

    readonly property string catalogName: "Dark_Theme"

    //====== Background colors:
    readonly property color backgroundGradColor1: "#130170"
    readonly property color backgroundGradColor2: "#0B0141"
    readonly property color menuButtonBackgroundColor: "#372C6A"
    readonly property color menuButtonIconColor: "#A5A0BD"
    readonly property color menuButtonPressedBackgroundColor: "#1B124C"
    readonly property color menuButtonActiveShadowColor: "#A5A0BD"
    readonly property color menuButtonBorderColor: "#A5A0BD"
//    readonly property color cellBorderColor: "#707070"
    readonly property color toolbarBackgroundColor: "#1B124C"
    readonly property color toolbuttonIconColor: "#A5A0BD"
    readonly property color cellBackgroundColor: "#1D1243"
    readonly property color cellBorderColor: "#8567A0"
    readonly property color themeSwitcherCheckedColor: "#8780AB"
    readonly property color themeSwitcherHandleColor: "#2F2369"

    readonly property color mainTextColor: "#CFCCE0"
    readonly property color secondaryTextColor: "#FFFFFF"

    readonly property color alertColor: "#DC143C"
    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.8
    readonly property real cellBackgroundOpacity: 0.38
    readonly property real themeSwitcherOpacity: 0.8
    readonly property real toolbarBackgroundOpacity: 0.7

    //====== Images:
    property url mainMenuImage: "qrc:/resources/images/cats/Start_Cats/SVG/Start_Cat_Dark_Theme.svg"
    property url scoreImage: "qrc:/resources/icons/Dark_Theme/cat_score.svg"
}
