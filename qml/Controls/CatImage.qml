import QtQuick 2.12

import Singletons 1.0

Item {
    id: root

    property real __cof: width / 100
    property var catObject

    clip: true

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.parts || {}) : 0

        delegate: Image {
            x: catObject.parts[modelData].split(";")[0].split(",")[0] * root.__cof
            y: catObject.parts[modelData].split(";")[0].split(",")[1] * root.__cof
            width: catObject.parts[modelData].split(";")[1].split(",")[0] * root.__cof
            height: catObject.parts[modelData].split(";")[1].split(",")[1] * root.__cof
            sourceSize.width: width
            sourceSize.height: height
            source: catObject["catImagePrefix"].replace("%THEME%", ThemeManager.currentTheme.catalogName) + modelData + ".svg"
        }
    }

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.clouds || {}) : 0

        delegate: Image {
            x: catObject.clouds[modelData].split(";")[0].split(",")[0] * root.__cof
            y: catObject.clouds[modelData].split(";")[0].split(",")[1] * root.__cof
            width: catObject.clouds[modelData].split(";")[1].split(",")[0] * root.__cof
            height: catObject.clouds[modelData].split(";")[1].split(",")[1] * root.__cof
            sourceSize.width: width
            sourceSize.height: height
            rotation: -catObject.clouds[modelData].split(";")[2] || 0  //### TODO WTF ?!
            source: catObject["cloudImagePrefix"].replace("%THEME%", ThemeManager.currentTheme.catalogName) + modelData + ".svg"
        }
    }
}
