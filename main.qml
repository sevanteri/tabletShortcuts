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

    property int cellWidth: buttonWidth + 10
    property int cellHeight: buttonHeight + 10

    property string buttonColor: "#000000"
    property string buttonColorToggled: "#552222"

    property int fontSize: 12

    width: 800
    height: 600

    color: "#555555"

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: padding
        interactive: true

        contentHeight: contentColumn.height

        Column {
            id: contentColumn

            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.floor(
                    (parent.width - padding*2) / root.cellWidth) * 
                    root.cellWidth

            ListView {
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
                    
                    cellWidth: root.cellWidth
                    cellHeight: root.cellHeight

                    delegate: Loader {
                        width: root.buttonWidth
                        // text: title
                        source: (type === "toggle") ? "ToggleButton.qml" :
                                (type === "slider") ? "Slider.qml" :
                                "NormalButton.qml"
                    }
                }
            }

            Row {
                id: quitButtons

                height: 60

                y: contentColumn.height < flick.height ?
                    flick.height - height : y

                spacing: 10
                Button {
                    height: parent.height
                    text: "Quit"
                    onClicked: Qt.quit()
                }
                Button {
                    height: parent.height
                    text: "Hide"
                    onClicked: root.hideView()
                }
            } 
        }
    }

}