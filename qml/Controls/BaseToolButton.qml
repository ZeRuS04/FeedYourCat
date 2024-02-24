import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import Singletons 1.0

ToolButton {
    id: root

    property string iconSource: ""
    property QtObject round

    checkable: true

    contentItem: Image {
        width: height
        sourceSize.width: 54
        sourceSize.height: 54
        source: root.iconSource
        layer {
            enabled: true
            effect: ColorOverlay {
                color: !root.pressed ? ThemeManager.currentTheme["toolbuttonIconColor"]
                                     : Qt.lighter(ThemeManager.currentTheme["toolbuttonIconColor"],
                                                  ThemeManager.currentThemeIndex ? 1.5 : 0.5)
            }
        }
    }
    background: null
//    onPressed: {
//        round = roundComponent.createObject(root)
//        round.width = root.width * 1.7;
//    }
//    onReleased: round.destroy()

//    Component {
//        id: roundComponent

//        Rectangle {
//            anchors.centerIn: parent

//            width: 1
//            height: width
//            radius: width /2
//            color: ThemeManager.currentTheme["menuButtonBorderColor"]
//            opacity: 0.2

//            Behavior on width {
//                NumberAnimation {
//                    duration: 200
//                    alwaysRunToEnd: true
//                }
//            }
//        }
//    }
}
