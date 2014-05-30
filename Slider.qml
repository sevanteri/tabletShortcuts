import QtQuick 2.0

Rectangle {
    id: slider

    property alias text: titleText.text

    width: root.buttonWidth
    height: root.buttonHeight

    color: "#555"

    property real value: 1
    property real maximum: typeof(max) === 'undefined' ? 100 : max
    property real minimum: typeof(min) === 'undefined' ? 0 : min

    onValueChanged: {
        // console.log("onchange: " + value)

        var intOnly = typeof(integerOnly) !== 'undefined' ? 
                            integerOnly : false;

        var act = action.arg(intOnly ? Math.round(value) : value);

        console.log("Running cmd '" + act + "'");
        // run action
        root.runCommand(act); 
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        Text {
            id: titleText
            text: title
            color: "white"
            wrapMode: Text.WordWrap
            font.pointSize: root.fontSize
        }

        Rectangle {
            id: base

            color: Qt.lighter(slider.color, 1.5)

            width: parent.width
            height: titleText.text.length > 0 ?
                        parent.height - titleText.height - parent.spacing :
                        parent.height

            Text {
                id: valueLabel

                anchors.centerIn: parent
                text: value
            }

            Rectangle {
                id: handle
                color: "#000"

                anchors.verticalCenter: parent.verticalCenter

                width: 10
                height: parent.height

                onXChanged: {
                    if (x + width > base.width)
                        x = base.width - width;
                    if (x < 0)
                        x = 0;
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        drag.target: handle
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: base.width - handle.width


        onClicked: {
            handle.x = mouse.x - handle.width;
            updateValue();
        }

        onReleased: {
            updateValue();
        }
    }

    function updateValue() {
        slider.value = (maximum - minimum) * 
                        handle.x / (base.width - handle.width) +
                        minimum;
    }
}