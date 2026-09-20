#include "dash.h"

#include <QDateTime>
#include <QLocale>

Dash::Dash(QObject *parent)
    : QObject(parent)
{
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

void Dash::updateClock()
{
    const QDateTime now = QDateTime::currentDateTime();
    // 24h HH:mm:ss to match the instrument-cluster look of the mockup.
    m_clock = now.toString(QStringLiteral("HH:mm:ss"));
    m_date = QLocale::c().toString(now, QStringLiteral("ddd MMM d")).toUpper();
    emit clockChanged();
}
