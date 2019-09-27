import QtQuick 2.12

import Singletons 1.0

Item {
    id: root

    property var catObject

    clip: true

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.parts || {}) : 0

        delegate: Image {

            x: catObject.parts[modelData].split(";")[0].split(",")[0]
            y: catObject.parts[modelData].split(";")[0].split(",")[1]
            width: catObject.parts[modelData].split(";")[1].split(",")[0]
            height: catObject.parts[modelData].split(";")[1].split(",")[1]
            source: catObject["catImagePrefix"].replace("%THEME%", ThemeManager.currentTheme.catalogName) + modelData + ".svg"
        }
    }

    Repeater {
        model: !!root.catObject ? Object.keys(root.catObject.clouds || {}) : 0

        delegate: Image {

            x: catObject.clouds[modelData].split(";")[0].split(",")[0]
            y: catObject.clouds[modelData].split(";")[0].split(",")[1]
            width: catObject.clouds[modelData].split(";")[1].split(",")[0]
            height: catObject.clouds[modelData].split(";")[1].split(",")[1]
            source: catObject["cloudImagePrefix"].replace("%THEME%", ThemeManager.currentTheme.catalogName) + modelData + ".svg"
        }
    }

//    Image {
//        id: cloud1

//        x: catObject.cloud1.split(";")[0].split(",")[0]
//        y: catObject.cloud1.split(";")[0].split(",")[1]
//        width: catObject.cloud1.split(";")[1].split(",")[0]
//        height: catObject.cloud1.split(";")[1].split(",")[1]
//        source: "qrc:/resources/images/cats/Game_Cats/Cloud/Cloud_step_1.svg"
//    }

//    Image {
//        id: cloud2

//        x: catObject.cloud2.split(";")[0].split(",")[0]
//        y: catObject.cloud2.split(";")[0].split(",")[1]
//        width: catObject.cloud2.split(";")[1].split(",")[0]
//        height: catObject.cloud2.split(";")[1].split(",")[1]
//        source: "qrc:/resources/images/cats/Game_Cats/Cloud/Cloud_step_2.svg"
//    }

//    Image {
//        id: cloud3

//        x: catObject.cloud3.split(";")[0].split(",")[0]
//        y: catObject.cloud3.split(";")[0].split(",")[1]
//        width: catObject.cloud3.split(";")[1].split(",")[0]
//        height: catObject.cloud3.split(";")[1].split(",")[1]
//        source: "qrc:/resources/images/cats/Game_Cats/Cloud/Cloud_step_3.svg"
//    }

//    Image {
//        id: cloud4

//        x: catObject.cloud4.split(";")[0].split(",")[0]
//        y: catObject.cloud4.split(";")[0].split(",")[1]
//        width: catObject.cloud4.split(";")[1].split(",")[0]
//        height: catObject.cloud4.split(";")[1].split(",")[1]
//        source: "qrc:/resources/images/cats/Game_Cats/Cloud/Main_cloud.svg"
//    }
}
