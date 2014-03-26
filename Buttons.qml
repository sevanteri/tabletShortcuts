import QtQuick 2.0

ListModel {
    ListElement {
        buttons: [
            ListElement {
                title: "Quit"
                action: "quit"
            },
            ListElement {
                title: "Hide"
                action: "hide"
            }
        ]
    }
    ListElement {
        type: "group"
        buttons: [
            ListElement {
                title: "V+"
                action: "amixer -c0 set Master 1dB+"
                doNotHide: true
            }, 
            ListElement {
                title: "V-"
                action: "amixer -c0 set Master 1dB-"
                doNotHide: true
            },
            ListElement {
                title: "B+"
                action: "xbacklight -inc 10"
                doNotHide: true
            }, 
            ListElement {
                title: "B-"
                action: "xbacklight -dec 10"
                doNotHide: true
            }
        ]
    }

    ListElement {
        type: "group"
        buttons: [
            ListElement {
                type: "toggle"
                title: "Fing"
                action1: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch off"
                action2: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch on"
            },
            ListElement {
                type: "toggle"
                title: "Pad"
                action1: "synclient TouchpadOff=1"
                action2: "synclient TouchpadOff=0"
            },
            ListElement {
                type: "toggle"
                title: "Gest"
                action1: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture off"
                action2: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture on"
            }
        ]
    }

    ListElement {
        type: "group"
        buttons: [
              ListElement {title: "N"; action: "xrotate normal" }
            , ListElement {title: "I"; action: "xrotate inverted"}
            , ListElement {title: "L"; action: "xrotate left"}
            , ListElement {title: "R"; action: "xrotate right"}
            ]
    }
    ListElement {
        title: "XKill"
        action: "xkill"
    }
    ListElement {
        title: "Scrot"
        action: "scrot -s -e 'mv $f ~/'"
    }
}