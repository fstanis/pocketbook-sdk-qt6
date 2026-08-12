#include "device_info.h"

#include <QGuiApplication>

// Last, and only in this file: inkview.h carries unnamespaced macros such as BLACK and
// ALIGN_LEFT, which have no business reaching a translation unit that includes Qt.
#include <inkview.h>

ScreenSize openInkViewScreen() {
  InitInkview(TASK_MAKEACTIVE);
  return {ScreenWidth(), ScreenHeight(), PanelHeight()};
}

QString inkViewFontFamily() {
  const char *family = iv_get_default_font(FONT_FAMILY);
  return family != nullptr ? QString::fromUtf8(family) : QString();
}

DeviceInfo::DeviceInfo(ScreenSize screen, QObject *parent)
    : QObject(parent), screen_(screen) {}

QString DeviceInfo::model() const {
  return QString::fromUtf8(GetDeviceModel());
}

QString DeviceInfo::hardwareType() const {
  return QString::fromUtf8(GetHardwareType());
}

QString DeviceInfo::softwareVersion() const {
  return QString::fromUtf8(GetSoftwareVersion());
}

QString DeviceInfo::fontFamily() const {
  return inkViewFontFamily();
}

QString DeviceInfo::qtVersion() const {
  return QString::fromUtf8(qVersion());
}

QString DeviceInfo::platformName() const {
  return QGuiApplication::platformName();
}

int DeviceInfo::screenWidth() const {
  return screen_.width;
}

int DeviceInfo::screenHeight() const {
  return screen_.height;
}

int DeviceInfo::panelHeight() const {
  return screen_.panelHeight;
}
