#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "playercontroller.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("mistplayer");
    QCoreApplication::setApplicationName("mistplayer");

    QQuickStyle::setStyle("Basic");

    PlayerController controller;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("playerController", &controller);

    const QUrl url(QStringLiteral("qrc:/MistPlayer/qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
