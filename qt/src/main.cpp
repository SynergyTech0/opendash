#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QIcon>

#include "mediamodel.h"
#include "playbackcontroller.h"
#include "climatecontroller.h"
#include "dash.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("OpenDash"));
    app.setOrganizationName(QStringLiteral("OpenDash"));

    // Bundled display fonts (optional). Drop Chakra Petch / Barlow .ttf files in
    // qt/assets/fonts and they load here; otherwise the UI falls back to the
    // platform's condensed + sans fonts, which is fine on a Pi image.
    for (const QString &f : {QStringLiteral(":/assets/fonts/ChakraPetch-SemiBold.ttf"),
                             QStringLiteral(":/assets/fonts/ChakraPetch-Bold.ttf"),
                             QStringLiteral(":/assets/fonts/Barlow-Regular.ttf"),
                             QStringLiteral(":/assets/fonts/Barlow-SemiBold.ttf")}) {
        QFontDatabase::addApplicationFont(f); // no-op if the file isn't present
    }

    QQmlApplicationEngine engine;

    // The C++ backend. One media library, shared by the list view and the
    // playback controller, plus climate and the app shell. Exposed to QML as
    // context singletons — the idiomatic split for a Qt HMI.
    auto *library  = new MediaModel(&app);
    auto *playback = new PlaybackController(library, &app);
    auto *climate  = new ClimateController(&app);
    auto *dash     = new Dash(&app);

    engine.rootContext()->setContextProperty(QStringLiteral("Library"), library);
    engine.rootContext()->setContextProperty(QStringLiteral("Playback"), playback);
    engine.rootContext()->setContextProperty(QStringLiteral("Climate"), climate);
    engine.rootContext()->setContextProperty(QStringLiteral("Dash"), dash);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, [] { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    // Explicit qrc path (works on Qt 6.4, unlike loadFromModule which is 6.5+).
    // Matches RESOURCE_PREFIX "/" + URI OpenDash in CMakeLists.txt.
    engine.load(QUrl(QStringLiteral("qrc:/OpenDash/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
