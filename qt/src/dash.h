#pragma once

#include <QObject>
#include <QTimer>

// App-level shell state: which view is showing, night/day, units, brightness,
// and the live clock. Kept separate from the media/climate controllers so each
// concern stays small and testable.
class Dash : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString view READ view WRITE setView NOTIFY viewChanged)
    Q_PROPERTY(bool day READ day WRITE setDay NOTIFY dayChanged)
    Q_PROPERTY(QString units READ units NOTIFY unitsChanged)   // "F" / "C"
    Q_PROPERTY(int brightness READ brightness NOTIFY brightnessChanged)
    Q_PROPERTY(QString clock READ clock NOTIFY clockChanged)
    Q_PROPERTY(QString date READ date NOTIFY clockChanged)
    Q_PROPERTY(int outsideTempF READ outsideTempF CONSTANT)

public:
    explicit Dash(QObject *parent = nullptr);

    QString view() const { return m_view; }
    bool day() const { return m_day; }
    QString units() const { return m_units; }
    int brightness() const { return m_brightness; }
    QString clock() const { return m_clock; }
    QString date() const { return m_date; }
    int outsideTempF() const { return 41; }

    void setView(const QString &v);
    void setDay(bool on);

public slots:
    void toggleUnits();

signals:
    void viewChanged();
    void dayChanged();
    void unitsChanged();
    void brightnessChanged();
    void clockChanged();

private:
    void updateClock();

    QString m_view = QStringLiteral("now");
    bool m_day = false;
    QString m_units = QStringLiteral("F");
    int m_brightness = 80;
    QString m_clock;
    QString m_date;
    QTimer m_clockTimer;
};
