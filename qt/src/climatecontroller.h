#pragma once

#include <QObject>

// Dual-zone HVAC state. In a real head unit these setters would write to the
// CAN-bus climate ECU; here they just hold state and notify the UI. The shape
// (properties + invokable nudges) is what a QML HMI binds against either way.
class ClimateController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int driverTemp READ driverTemp NOTIFY changed)
    Q_PROPERTY(int passengerTemp READ passengerTemp NOTIFY changed)
    Q_PROPERTY(int fan READ fan WRITE setFan NOTIFY changed)
    Q_PROPERTY(bool ac READ ac NOTIFY changed)
    Q_PROPERTY(bool autoMode READ autoMode NOTIFY changed)
    Q_PROPERTY(bool recirc READ recirc NOTIFY changed)
    Q_PROPERTY(bool defrostFront READ defrostFront NOTIFY changed)
    Q_PROPERTY(bool defrostRear READ defrostRear NOTIFY changed)
    Q_PROPERTY(int seatLeft READ seatLeft NOTIFY changed)   // 0..3
    Q_PROPERTY(int seatRight READ seatRight NOTIFY changed)  // 0..3

public:
    explicit ClimateController(QObject *parent = nullptr);

    int driverTemp() const { return m_driverTemp; }
    int passengerTemp() const { return m_passengerTemp; }
    int fan() const { return m_fan; }
    bool ac() const { return m_ac; }
    bool autoMode() const { return m_auto; }
    bool recirc() const { return m_recirc; }
    bool defrostFront() const { return m_defrostF; }
    bool defrostRear() const { return m_defrostR; }
    int seatLeft() const { return m_seatL; }
    int seatRight() const { return m_seatR; }

    void setFan(int f);

public slots:
    // "driver" / "passenger", delta of +1 / -1, clamped 60..85.
    void nudgeTemp(const QString &zone, int delta);
    // "ac" / "auto" / "recirc" / "defrostFront" / "defrostRear"
    void toggle(const QString &key);
    // side == "seatLeft" / "seatRight"; tapping the active level turns it down.
    void setSeat(const QString &side, int level);

signals:
    void changed();

private:
    int m_driverTemp = 70;
    int m_passengerTemp = 72;
    int m_fan = 3;
    bool m_ac = true;
    bool m_auto = true;
    bool m_recirc = false;
    bool m_defrostF = false;
    bool m_defrostR = false;
    int m_seatL = 2;
    int m_seatR = 0;
};
