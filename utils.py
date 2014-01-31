#!/usr/bin/python
# -*- coding: utf-8 -*-

from PyQt5.QtCore import QObject, Q_CLASSINFO, pyqtSlot

from PyQt5.QtDBus import QDBusAbstractAdaptor

from evdev import InputDevice, _input, DeviceInfo
import os

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

class ROInputDevice(InputDevice):
    def __init__(self, dev, flags):
        '''
        :param dev: path to input device
        :param flags: flags for os.open
        '''

        #: Path to input device.
        self.fn = dev

        #: A non-blocking file descriptor to the device file.
        self.fd = os.open(dev, flags)

        # Returns (bustype, vendor, product, version, name, phys, capabilities).
        info_res = _input.ioctl_devinfo(self.fd)

        #: A :class:`DeviceInfo <evdev.device.DeviceInfo>` instance.
        self.info = DeviceInfo(*info_res[:4])

        #: The name of the event device.
        self.name = info_res[4]

        #: The physical topology of the device.
        self.phys = info_res[5]

        #: The evdev protocol version.
        self.version = _input.ioctl_EVIOCGVERSION(self.fd)

        #: The raw dictionary of device capabilities - see `:func:capabilities()`.
        self._rawcapabilities = _input.ioctl_capabilities(self.fd)