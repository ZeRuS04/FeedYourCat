#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "vibrator.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    Vibrator vibrator;
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Eugene Sinel");
    app.setOrganizationDomain("eugene.sinel.com");
    app.setApplicationName("Feed Your Cat");

    qmlRegisterSingletonType(QUrl("qrc:/qml/singletons/Common.qml"), "Singletons", 1, 0, "Common");
    qmlRegisterSingletonType(QUrl("qrc:/qml/singletons/GameLogic.qml"), "Singletons", 1, 0, "Logic");
    qmlRegisterSingletonType(QUrl("qrc:/qml/singletons/ThemeManager.qml"), "Singletons", 1, 0, "ThemeManager");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("Vibrator", &vibrator);
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
