#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os

from PyQt5.QtCore import QUrl

from PyQt5.QtDBus import QDBusConnection

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView

from subprocess import Popen, PIPE
import re, shlex

import threading

import evdev
from evdev import ecodes
from select import select

from utils import MyDBUSServer, ROInputDevice


class EdgeClickThread(threading.Thread):
    def __init__(self, app):
        threading.Thread.__init__(self)
        self.dev = None
        self._end = threading.Event()
        self.app = app

        self.last_x = -1
        self.last_y = -1

        self.max_x = -1
        self.max_y = -1

        self.orientations = {"none": 0,
                             "cw": 1,
                             "half": 2,
                             "ccw": 3}

        self.actions = [self.handleLeftEdge,
                        self.handleTopEdge,
                        self.handleRightEdge,
                        self.handleBottomEdge]

        print("getting device")
        for d in evdev.list_devices():
            de = ROInputDevice(d, os.O_RDONLY | os.O_NONBLOCK)
            if de.name.rfind("Finger") > 0:
                self.dev = de
                break

        print("device: ", self.dev)
        if self.dev:
            for cap in self.dev.capabilities()[ecodes.EV_ABS]:
                if cap[0] == ecodes.ABS_MT_POSITION_X:
                    self.max_x = cap[1].max
                elif cap[0] == ecodes.ABS_MT_POSITION_Y:
                    self.max_y = cap[1].max

            print("max x: ", self.max_x)
            print("max y: ", self.max_y)

            
    def run(self):
        if not self.dev:
            return
        
        self._end.clear()
        while not self.stopped:
            r, w, x = select([self.dev.fd], [], [], 0.05)
            if r:
                if self.stopped:
                    break
                for event in self.dev.read():
                    if event.code == ecodes.ABS_MT_POSITION_X:
                        self.handleXChange(event.value)
                    elif event.code == ecodes.ABS_MT_POSITION_Y:
                        self.handleYChange(event.value)

    def handleXChange(self, x):
        if x == 0:
            rotation = self.getScreenRotation()
            self.actions[0 - self.orientations[rotation]]()
        elif x == self.max_x:
            rotation = self.getScreenRotation()
            self.actions[2 - self.orientations[rotation]]()

    def handleYChange(self, y):
        if y == 0:
            rotation = self.getScreenRotation()
            self.actions[1 - self.orientations[rotation]]()
        elif y == self.max_y:
            rotation = self.getScreenRotation()
            self.actions[3 - self.orientations[rotation]]()

    def handleLeftEdge(self):
        self.app.showView()

    def handleTopEdge(self):
        pass

    def handleRightEdge(self):
        pass

    def handleBottomEdge(self):
        pass

    def getScreenRotation(self):
        output = Popen("xsetwacom --get 'Wacom ISDv4 E6 Finger touch' Rotate", shell=True, stdout=PIPE)\
                        .communicate()[0].decode('UTF-8').strip()

        return output

    def end(self):
        self._end.set()

    @property
    def stopped(self):
        return self._end.isSet()


class TabletShortcuts(QGuiApplication):
    def __init__(self, argv):
        QGuiApplication.__init__(self, argv)

        self.view = QQuickView()

        self.bus = QDBusConnection.sessionBus()
        self.server = MyDBUSServer(self)
        self.bus.registerObject("/app", self.server)
        self.bus.registerService("sevanteri.TabletShortcuts")

        self.th = EdgeClickThread(self)
        self.th.start();

        self.view.setTitle("TabletShortcuts")
        self.view.setResizeMode(QQuickView.SizeRootObjectToView)
        self.view.setSource(QUrl('main.qml'))

        self.root = self.view.rootObject()
        self.showView()

        self.root.runCommand.connect(self.run)
        self.root.hideView.connect(self.view.hide)

        self.view.engine().quit.connect(self.quit)

    def run(self, cmd):
        return Popen(shlex.split(cmd))

    def quit(self):
        self.th.end()
        self.th.join()
        self.exit()

    def showView(self):
        if self.view.isVisible():
            self.view.hide()
        else:
            width, height = TabletShortcuts.getScreenGeometry()

            self.view.setGeometry(1, 1, 80, height)
            self.view.show()

    def getScreenGeometry():
        output = Popen("xrandr | grep 'current'", shell=True, stdout=PIPE)\
                        .communicate()[0].decode('UTF-8')

        m = re.search('current.([0-9]+).x.([0-9]+)', output)
        width = int(m.group(1))
        height = int(m.group(2))

        return (width, height)


def main():
    # root.setAttribute(Qt.WA_ShowWithoutActivating)
    app = TabletShortcuts(sys.argv)

    sys.exit(app.exec_())

if __name__ == '__main__':
    main()