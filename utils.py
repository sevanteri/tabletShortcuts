#!/usr/bin/python
# -*- coding: utf-8 -*-

from PyQt5.QtCore import QObject, Q_CLASSINFO, pyqtSlot

from PyQt5.QtDBus import QDBusAbstractAdaptor


class ServerAdaptor(QDBusAbstractAdaptor):
    """ This provides the DBus adaptor to the outside world"""

    Q_CLASSINFO("D-Bus Interface", "sevanteri.TabletShortcuts")
    Q_CLASSINFO("D-Bus Introspection",
        '  <interface name="sevanteri.TabletShortcuts">\n'
        '    <method name="hideshow" />\n'
        '  </interface>\n')

    def __init__(self, parent, app):
        super().__init__(parent)
        self.app = app

    @pyqtSlot()
    def hideshow(self):
        self.app.showView()


class MyDBUSServer(QObject):

    def __init__(self, app):
        QObject.__init__(self)
        self.__dbusAdaptor = ServerAdaptor(self, app)
        self.app = app
