#include "dash.h"

#include <QDateTime>
#include <QLocale>
#include <QSettings>

Dash::Dash(QObject *parent)
    : QObject(parent)
{
    loadPrefs();
    updateClock();
    m_clockTimer.setInterval(1000);
    connect(&m_clockTimer, &QTimer::timeout, this, &Dash::updateClock);
    m_clockTimer.start();
}

void Dash::setView(const QString &v)
{
    if (v == m_view)
        return;
    m_view = v;
    emit viewChanged();
}

void Dash::setDay(bool on)
{
    if (on == m_day)
        return;
    m_day = on;
    emit dayChanged();
}

void Dash::toggleUnits()
{
    m_units = (m_units == QLatin1String("F")) ? QStringLiteral("C") : QStringLiteral("F");
    emit unitsChanged();
}

void Dash::setBgPreset(const QString &key)
{
    m_bgType = QStringLiteral("preset");
    m_bgKey = key;
    m_bgImage.clear();
    saveBg();
    emit bgChanged();
}

void Dash::setBgImage(const QUrl &url)
{
    if (url.isEmpty())
        return;
    m_bgType = QStringLiteral("image");
    m_bgImage = url;
    m_bgKey.clear();
    saveBg();
    emit bgChanged();
}

void Dash::clearBg()
{
    m_bgType = QStringLiteral("none");
    m_bgKey.clear();
    m_bgImage.clear();
    saveBg();
    emit bgChanged();
}

void Dash::loadPrefs()
{
    QSettings s;
    m_bgType = s.value(QStringLiteral("bg/type"), QStringLiteral("none")).toString();
    m_bgKey = s.value(QStringLiteral("bg/key")).toString();
    m_bgImage = s.value(QStringLiteral("bg/image")).toUrl();
}

void Dash::saveBg()
{
    QSettings s;
    s.setValue(QStringLiteral("bg/type"), m_bgType);
    s.setValue(QStringLiteral("bg/key"), m_bgKey);
    s.setValue(QStringLiteral("bg/image"), m_bgImage);
}

void Dash::updateClock()
{
    const QDateTime now = QDateTime::currentDateTime();
    // 24h HH:mm:ss to match the instrument-cluster look of the mockup.
    m_clock = now.toString(QStringLiteral("HH:mm:ss"));
    m_date = QLocale::c().toString(now, QStringLiteral("ddd MMM d")).toUpper();
    emit clockChanged();
}
