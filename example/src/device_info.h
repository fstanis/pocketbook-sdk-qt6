#pragma once

#include <QObject>
#include <QString>

/** The panel geometry InkView reports, in pixels; zeroes mean the screen never opened. */
struct ScreenSize {
  int width;
  int height;
  /** The firmware's own status bar along the top, which ScreenHeight() does not subtract. */
  int panelHeight;
};

/**
 * Opens the e-ink panel and registers this process as the active task; must run before
 * QGuiApplication, or the app draws into a framebuffer the panel is not showing.
 */
ScreenSize openInkViewScreen();

/** The font family the firmware itself uses, or empty if InkView reports none. */
QString inkViewFontFamily();

/** The device facts the scene displays and sizes itself from. */
class DeviceInfo : public QObject {
  Q_OBJECT

  Q_PROPERTY(QString model READ model CONSTANT)
  Q_PROPERTY(QString hardwareType READ hardwareType CONSTANT)
  Q_PROPERTY(QString softwareVersion READ softwareVersion CONSTANT)
  Q_PROPERTY(QString fontFamily READ fontFamily CONSTANT)
  Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)
  Q_PROPERTY(QString platformName READ platformName CONSTANT)
  Q_PROPERTY(int screenWidth READ screenWidth CONSTANT)
  Q_PROPERTY(int screenHeight READ screenHeight CONSTANT)
  Q_PROPERTY(int panelHeight READ panelHeight CONSTANT)

 public:
  explicit DeviceInfo(ScreenSize screen, QObject *parent = nullptr);

  QString model() const;
  QString hardwareType() const;
  QString softwareVersion() const;
  QString fontFamily() const;
  QString qtVersion() const;
  QString platformName() const;

  int screenWidth() const;
  int screenHeight() const;
  int panelHeight() const;

 private:
  ScreenSize screen_;
};
