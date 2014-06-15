import QtQuick 2.0

Button {
    id: button

    onClicked: confirming.visible = true

    Rectangle {
        id: confirming
        anchors.fill: parent
        visible: false
        color: "#00BB00"

        Label {
            text: "Really?"
        }
        Label {
            text: "Yes"
            anchors.fill: none
            anchors.bottom: parent.bottom
            anchors.right: nope.left
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var hide = typeof(hideAfter) !== 'undefined' ? hideAfter : false;
                // console.debug(hide);

                if (hide)
                    root.hideView();

                confirming.visible = false

                console.debug("Running cmd '" + action + "'");
                // run action
                root.runCommand(action);
            }
        }
        Rectangle {
            id: nope
            color: "#b00"

            anchors.fill: parent
            anchors.leftMargin: parent.width * 0.75
            Label {
                text: "No"
                anchors.fill: none
                anchors.bottom: parent.bottom
                anchors.left: nope.left
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    confirming.visible = false
                }
            }
        }
    }
}