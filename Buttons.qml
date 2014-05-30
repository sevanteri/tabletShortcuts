import QtQuick 2.0

ListModel {
    ListElement {
        elements: [
            ListElement {
                type: "slider"
                title: "Volume"
                action: "amixer -c0 set Master %1"
                max: 87
                min: 0
            },
            ListElement {
                type: "slider"
                title: "Brightness"
                action: "xbacklight -set %1"
                min: 1
                max: 100
                //integerOnly: true
            }
        ]
    }

    ListElement {
        elements: [
            ListElement {
                type: "toggle"
                title: "Touch on/off"
                toggleOff: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch off"
                toggleOn: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch on"
            },
            ListElement {
                type: "toggle"
                title: "TouchPad on/off"
                toggleOff: "synclient TouchpadOff=1"
                toggleOn: "synclient TouchpadOff=0"
            },
            ListElement {
                type: "toggle"
                title: "Gestures on/off"
                toggleOff: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture off"
                toggleOn: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture on"
            }
        ]
    }

    ListElement {
        elements: [
             ListElement {title: "Rotate normal"; action: "xrotate normal" }
            ,ListElement {title: "Rotate inverted"; action: "xrotate inverted"}
            ,ListElement {title: "Rotate left"; action: "xrotate left"}
            ,ListElement {title: "Rotate right"; action: "xrotate right"}
        ]
    }
    
    ListElement {
        elements: [
            ListElement {
                title: "XKill"
                action: "xkill"
            },
            ListElement {
                title: "Scrot"
                action: "scrot -s -e 'mv $f ~/'"
            }
        ]
    }
}