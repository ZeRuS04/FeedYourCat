pragma Singleton

import QtQuick 2.12
import Qt.labs.settings 1.1

QtObject {
    id: root

    readonly property var defaultTheme: __darkTheme
    readonly property var currentTheme: {
        switch (currentThemeIndex) {
            case 0: return __lightTheme;
            case 1: return __darkTheme;
            default: return __darkTheme;
        }
    }
    property int currentThemeIndex: 1
    property var __lightTheme: null
    property var __darkTheme: null

    property Settings settings: Settings {
        property alias currentThemeIndex: root.currentThemeIndex
    }

    property ListModel themesModel: ListModel {
        ListElement {
            text: qsTr("Light Theme")
            value: "Light_Theme"
        }
        ListElement {
            text: qsTr("Dark Theme")
            value: "Dark_Theme"
        }
    }

    function init() {
        loadLightTheme();
        loadDarkSpaceTheme();
    }

    function loadLightTheme() {
        var component = Qt.createComponent("../themes/LightTheme.qml");
        if (component.status === Component.Ready) {
            root.__lightTheme = component.createObject(root);
        } else {
            console.error('Default theme loading error', component.errorString())
        }
    }

    function loadDarkSpaceTheme() {
        var component = Qt.createComponent("../themes/DarkTheme.qml");
        if (component.status === Component.Ready) {
            root.__darkTheme = component.createObject(root);
        } else {
            console.error('Dark Space theme loading error', component.errorString())
        }
    }

    Component.onCompleted: init()

}

