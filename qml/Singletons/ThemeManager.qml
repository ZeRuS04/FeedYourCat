pragma Singleton

import QtQuick 2.0

QtObject {
    id: root

    readonly property var defaultTheme: __lightTheme
    readonly property var currentTheme: {
        switch (currentThemeIndex) {
            case 0: return __lightTheme;
            case 1: return __darkTheme;
            default: return __lightTheme;
        }
    }
    property int currentThemeIndex: 0
    property var __lightTheme: null
    property var __darkTheme: null

    property ListModel themesModel: ListModel {
        ListElement {
            text: qsTr("Light Theme")
            value: 0
        }
        ListElement {
            text: qsTr("Dark Theme")
            value: 1
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

