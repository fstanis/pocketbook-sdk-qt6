#include <QByteArray>
#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QString>
#include <QUrl>

#include "device_info.h"

namespace {

constexpr const char *kPluginPath = "/ebrmain/plugins";
constexpr const char *kQmlPath = "/ebrmain/qml";
constexpr const char *kPlatformName = "pocketbook2";
constexpr const char *kSceneUrl = "qrc:/main.qml";

/** Points Qt at the firmware's plugin tree and platform, letting the environment override both. */
void selectPlatformPlugin() {
  if (qEnvironmentVariableIsEmpty("QT_PLUGIN_PATH")) {
    qputenv("QT_PLUGIN_PATH", QByteArray(kPluginPath));
  }
  if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")) {
    qputenv("QT_QPA_PLATFORM", QByteArray(kPlatformName));
  }
}

}  // namespace

int main(int argc, char *argv[]) {
  selectPlatformPlugin();

  // The launcher starts apps in a way that trips Qt's setuid check.
  QCoreApplication::setSetuidAllowed(true);

  const ScreenSize screen = openInkViewScreen();

  // No GPU and no OpenGL on this device, and the choice has to precede any QQuickWindow.
  QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);

  QGuiApplication app(argc, argv);

  // The firmware's own Qt apps all take their font from InkView, so fontconfig evidently does
  // not produce a usable default here.
  const QString fontFamily = inkViewFontFamily();
  if (!fontFamily.isEmpty()) {
    QGuiApplication::setFont(QFont(fontFamily));
  }

  DeviceInfo deviceInfo(screen);

  QQmlApplicationEngine engine;
  // Where com.pocketbook.controls lives; nothing relates an app on /mnt/ext1 to /ebrmain.
  engine.addImportPath(QString::fromUtf8(kQmlPath));
  engine.rootContext()->setContextProperty(QStringLiteral("deviceInfo"), &deviceInfo);

  engine.load(QUrl(QString::fromUtf8(kSceneUrl)));
  if (engine.rootObjects().isEmpty()) {
    return 1;
  }
  return app.exec();
}
