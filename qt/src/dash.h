#pragma once

#include <QObject>
#include <QTimer>
#include <QUrl>

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
    // Dash background: "none" | "preset" | "image". Chosen in Settings, remembered
    // across launches via QSettings. bgKey names a built-in preset; bgImage is a
    // user-picked photo. Mirrors the web preview's background picker.
    Q_PROPERTY(QString bgType READ bgType NOTIFY bgChanged)
    Q_PROPERTY(QString bgKey READ bgKey NOTIFY bgChanged)
    Q_PROPERTY(QUrl bgImage READ bgImage NOTIFY bgChanged)

public:
    explicit Dash(QObject *parent = nullptr);

    QString view() const { return m_view; }
    bool day() const { return m_day; }
    QString units() const { return m_units; }
    int brightness() const { return m_brightness; }
    QString clock() const { return m_clock; }
    QString date() const { return m_date; }
    int outsideTempF() const { return 41; }
    QString bgType() const { return m_bgType; }
    QString bgKey() const { return m_bgKey; }
    QUrl bgImage() const { return m_bgImage; }

    void setView(const QString &v);
    void setDay(bool on);

public slots:
    void toggleUnits();
    void setBgPreset(const QString &key);
    void setBgImage(const QUrl &url);
    void clearBg();

signals:
    void viewChanged();
    void dayChanged();
    void unitsChanged();
    void brightnessChanged();
    void clockChanged();
    void bgChanged();

private:
    void updateClock();
    void loadPrefs();
    void saveBg();

    QString m_view = QStringLiteral("now");
    bool m_day = false;
    QString m_units = QStringLiteral("F");
    int m_brightness = 80;
    QString m_clock;
    QString m_date;
    QString m_bgType = QStringLiteral("none");
    QString m_bgKey;
    QUrl m_bgImage;
    QTimer m_clockTimer;
};
