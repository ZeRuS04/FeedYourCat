import QtQuick 2.0
import QtQuick.Controls 2.12
import Singletons 1.0

ToolButton {
    id: root

    property QtObject round

    checkable: true

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
