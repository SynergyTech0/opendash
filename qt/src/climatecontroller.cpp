#include "climatecontroller.h"

#include <QtGlobal>

ClimateController::ClimateController(QObject *parent)
    : QObject(parent)
{
}

void ClimateController::setFan(int f)
{
    f = qBound(0, f, 6);
    if (f == m_fan)
        return;
    m_fan = f;
    emit changed();
}

void ClimateController::nudgeTemp(const QString &zone, int delta)
{
    int *target = nullptr;
    if (zone == QLatin1String("driver"))
        target = &m_driverTemp;
    else if (zone == QLatin1String("passenger"))
        target = &m_passengerTemp;
    if (!target)
        return;

    *target = qBound(60, *target + delta, 85);
    emit changed();
}

void ClimateController::toggle(const QString &key)
{
    if (key == QLatin1String("ac"))            m_ac = !m_ac;
    else if (key == QLatin1String("auto"))     m_auto = !m_auto;
    else if (key == QLatin1String("recirc"))   m_recirc = !m_recirc;
    else if (key == QLatin1String("defrostFront")) m_defrostF = !m_defrostF;
    else if (key == QLatin1String("defrostRear"))  m_defrostR = !m_defrostR;
    else return;

    emit changed();
}

void ClimateController::setSeat(const QString &side, int level)
{
    level = qBound(0, level, 3);
    int *target = nullptr;
    if (side == QLatin1String("seatLeft"))
        target = &m_seatL;
    else if (side == QLatin1String("seatRight"))
        target = &m_seatR;
    if (!target)
        return;

    // Tapping the current level steps it back down (matches the web toggle).
    *target = (*target == level) ? level - 1 : level;
    if (*target < 0)
        *target = 0;
    emit changed();
}
