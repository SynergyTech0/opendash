#pragma once

#include <QObject>
#include <QTimer>

class MediaModel;

// Owns "what is playing": the current index, transport state, and a 1 Hz tick
// that advances the position exactly like a real player would. The UI binds to
// these properties; it never computes playback state itself.
class PlaybackController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int index READ index NOTIFY nowPlayingChanged)
    Q_PROPERTY(QString title READ title NOTIFY nowPlayingChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY nowPlayingChanged)
    Q_PROPERTY(int duration READ duration NOTIFY nowPlayingChanged)
    Q_PROPERTY(int seed READ seed NOTIFY nowPlayingChanged)
    Q_PROPERTY(int position READ position NOTIFY positionChanged)
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool shuffle READ shuffle NOTIFY modesChanged)
    Q_PROPERTY(bool repeat READ repeat NOTIFY modesChanged)
    Q_PROPERTY(bool hasTrack READ hasTrack NOTIFY nowPlayingChanged)

public:
    explicit PlaybackController(MediaModel *library, QObject *parent = nullptr);

    int index() const { return m_index; }
    QString title() const;
    QString artist() const;
    int duration() const;
    int seed() const;
    int position() const { return m_position; }
    bool playing() const { return m_playing; }
    int volume() const { return m_volume; }
    QString source() const { return m_source; }
    bool shuffle() const { return m_shuffle; }
    bool repeat() const { return m_repeat; }
    bool hasTrack() const;

    void setVolume(int v);
    void setSource(const QString &s);

public slots:
    void playPause();
    void next();
    void prev();
    void toggleShuffle();
    void toggleRepeat();
    void playAt(int row);          // pick a track from the media list
    void seekFraction(qreal frac); // scrub the progress bar (0..1)
    void deleteCurrent();          // the headline feature
    void deleteAt(int row);        // delete from the list without switching view

signals:
    void nowPlayingChanged();
    void positionChanged();
    void playingChanged();
    void volumeChanged();
    void sourceChanged();
    void modesChanged();
    // Ask the UI to raise a toast. danger == destructive (delete).
    void toast(const QString &message, bool danger);

private:
    void tick();
    void clampIndex();

    MediaModel *m_library;
    QTimer m_timer;
    int m_index = 1;
    int m_position = 64;
    bool m_playing = true;
    int m_volume = 62;
    QString m_source = QStringLiteral("USB");
    bool m_shuffle = false;
    bool m_repeat = false;
};
