pragma Singleton

import QtQuick 2.0

Item {
    property var catBackgrounds: ["#00DFCF","#6600BF","#FD948E","#ABE388","#D27AFF","#E6E68A"]
    property var catBorders: ["#009294","#4F0094","#FF4D0D","#006428","#B420FF","#946C00"]
    property string titleFont: fooFont.name

    FontLoader {
        id: fooFont;
        source: "qrc:/resources/fonts/foo.otf"
    }
}
