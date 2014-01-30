import QtQuick 2.0

Rectangle {
    id: root

    signal runCommand(string cmd);
    signal hideView();
    signal quitClicked()

    width: 80
    height: 1366


    color: "#555555"

    Buttons {id: buttonModel}

    ListView {
        id: listView
        model: buttonModel
        anchors.fill: parent
        // orientation: Qt.Horizontal
        spacing: 5

        delegate: Loader {
            width: root.width
            source: (buttons) ? "ButtonGroup.qml" : 
                    (type === "toggle") ? "ToggleButton.qml" :
                    "NormalButton.qml"
        }
    }

}