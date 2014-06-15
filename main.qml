import QtQuick 2.0

Rectangle {
    id: root

    signal runCommand(string cmd);
    signal hideView();
    signal quitClicked()

    property int padding: 20
    property int minButtonWidth: 60
    property int minButtonHeight: 40
    property int buttonWidth: Math.ceil(
                                (width - padding*2) /
                                (minButtonWidth*8)) *
                                 minButtonWidth

    property int buttonHeight: Math.ceil(
                                (width - padding*2) /
                                (minButtonWidth*8)) *
                                 minButtonHeight

    property int cellWidth: buttonWidth + padding/2
    property int cellHeight: buttonHeight + padding/2

    property string buttonColor: "#000000"
    property string buttonColorToggled: "#552222"

    property int fontSize: Math.ceil(
                            (width - padding*2) /
                            (minButtonWidth*8)) * 8

    width: 1366
    height: 768

    color: "#555555"

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: padding
        interactive: false

        contentHeight: contentColumn.height

        Column {
            id: contentColumn

            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.floor(
                    (parent.width - padding*2) / root.cellWidth) * 
                    root.cellWidth

            ListView {
                id: rows

                model: Buttons {}

                width: parent.width
                height: model.count * root.cellHeight

                spacing: 5

                interactive: false

                delegate: GridView {
                    id: grid

                    model: elements

                    interactive: false

                    width: parent.width
                    height: Math.ceil(model.count * 
                                        cellWidth / width) * 
                                        cellHeight
                    
                    property bool stretchElements: 
                        model.count * root.cellWidth - parent.width < 0

                    cellWidth: stretchElements ?
                                    Math.floor(parent.width / model.count) :
                                    root.cellWidth

                    cellHeight: root.cellHeight

                    delegate: Loader {
                        width: grid.cellWidth - padding/2
                        height: root.buttonHeight

                        source: (type === "toggle") ? "ToggleButton.qml" :
                                (type === "slider") ? "Slider.qml" :
                                (type === "confirm") ? "ConfirmButton.qml" :
                                "NormalButton.qml"
                    }
                }
            }

            Row {
                id: quitButtons

                height: root.buttonHeight

                y: contentColumn.height < flick.height ?
                    flick.height - height : 
                    rows.height

                spacing: 10
                Button {
                    width: root.buttonWidth
                    height: parent.height
                    text: "Quit"
                    onClicked: Qt.quit()
                }
                Button {
                    width: root.buttonWidth
                    height: parent.height
                    text: "Hide"
                    onClicked: root.hideView()
                }
            } 
        }
    }
}