import QtQuick 2.0

ListModel {

    ListElement {
        title: "Quit"
        action: "quit"
    }
    ListElement {
        title: "Hide"
        action: "hide"
    }
    ListElement {
        type: "slider"
        title: "Volume"
        action: "amixer -c0 set Master %1"
        max: 87
        min: 0
    }
    ListElement {
        title: "V+"
        action: "amixer -c0 set Master 1dB+"
        doNotHide: true
    } 
    ListElement {
        title: "V-"
        action: "amixer -c0 set Master 1dB-"
        doNotHide: true
    }
    ListElement {
        title: "B+"
        action: "xbacklight -inc 10"
        doNotHide: true
    } 
    ListElement {
        title: "B-"
        action: "xbacklight -dec 10"
        doNotHide: true
    }


    ListElement {
        type: "toggle"
        title: "Fing"
        toggleOff: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch off"
        toggleOn: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Touch on"
    }
    ListElement {
        type: "toggle"
        title: "Pad"
        toggleOff: "synclient TouchpadOff=1"
        toggleOn: "synclient TouchpadOff=0"
    }
    ListElement {
        type: "toggle"
        title: "Gest"
        toggleOff: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture off"
        toggleOn: "xsetwacom --set 'Wacom ISDv4 E6 Finger touch' Gesture on"
    }

    ListElement {title: "N"; action: "xrotate normal" }
    ListElement {title: "I"; action: "xrotate inverted"}
    ListElement {title: "L"; action: "xrotate left"}
    ListElement {title: "R"; action: "xrotate right"}
    
    ListElement {
        title: "XKill"
        action: "xkill"
    }
    ListElement {
        title: "Scrot"
        action: "scrot -s -e 'mv $f ~/'"
    }
}