import QtQuick 2.0

Rectangle {
    id: slider

    width: root.buttonWidth
    height: width

    color: "#555"

    property real value: 1
    property real max: 100
    property real min: 0

    onValueChanged: {
        // console.log("onchange: " + value)

        var intOnly = typeof(integerOnly) !== 'undefined' ? 
                            integerOnly : false;

        var act = action.arg(intOnly ? Math.round(value) : value);

        console.log("Running cmd '" + act + "'");
        // run action
        root.runCommand(act); 
    }

    Text {
        anchors.centerIn: parent
        text: title
        color: "white"
        wrapMode: Text.WordWrap
        font.pointSize: 12
    }

    Item {
        id: base
        anchors.fill: parent
        anchors.margins: 10

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
        slider.value = (max - min) * 
                            handle.x / (base.width - handle.width) +
                            min;
    }
}