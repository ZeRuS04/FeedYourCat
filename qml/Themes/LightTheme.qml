import QtQuick 2.0

QtObject {
    id: root

    readonly property string catalogName: "Light_Theme"

    //====== Background colors:
    readonly property color backgroundGradColor1: "#FFF8F9"
    readonly property color backgroundGradColor2: "#FFEDEF"
    readonly property color menuButtonBackgroundColor: "#FFD8DA"
    readonly property color menuButtonIconColor: "#0E1950"
    readonly property color menuButtonPressedBackgroundColor: "#F2B6B6"
    readonly property color menuButtonActiveShadowColor: "#FFEDEF"
    readonly property color menuButtonBorderColor: "#F7A1A1"
//    readonly property color cellBorderColor: "#707070"
    readonly property color toolbarBackgroundColor: "#F2B6B6"
    readonly property color toolbuttonIconColor: "#0E1950"
    readonly property color cellBackgroundColor: "#F6C9DF"
    readonly property color cellBorderColor: "#937187"
    readonly property color themeSwitcherCheckedColor: "#FFF7A1A1"
    readonly property color themeSwitcherHandleColor: "#FFFFD9DB"
    readonly property color timeBarBackgroundColor: "#FFEDEF"

    readonly property color mainTextColor: "#0E1950"
    readonly property color secondaryTextColor: "#0E1950"
    readonly property color thirdTextColor: "#1B124C"

    readonly property color alertColor: "#DC143C"

    readonly property color greenColor: "#ABE388"
    readonly property color yellowColor: "#E6E68A"
    readonly property color orangeColor: "#CC7552"
    readonly property color redColor: "#C13229"

    //====== Opacities:
    readonly property real menuButtonBackgroundOpacity: 0.8
    readonly property real cellBackgroundOpacity: 1.0
    readonly property real themeSwitcherOpacity: 0.7
    readonly property real toolbarBackgroundOpacity: 0.7

    //====== Images:
    property url mainMenuImage: "qrc:/resources/images/cats/Start_Cats/SVG/Start_Cat_Light_Theme.svg"
    property url pauseImage: "qrc:/resources/images/cats/Start_Cats/SVG/Cat_pause_Light_Theme.svg"
    property url scoreImage: "qrc:/resources/icons/Light_Theme/cat_score.svg"
}
