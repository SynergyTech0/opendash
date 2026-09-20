#include "playbackcontroller.h"
#include "mediamodel.h"

#include <QRandomGenerator>

PlaybackController::PlaybackController(MediaModel *library, QObject *parent)
    : QObject(parent)
    , m_library(library)
{
    clampIndex();

    // 1 Hz playback tick. Mirrors the mockup's setInterval(...,1000).
    m_timer.setInterval(1000);
    connect(&m_timer, &QTimer::timeout, this, &PlaybackController::tick);
    m_timer.start();

    // If the library empties out under us, keep the index sane.
    connect(m_library, &MediaModel::countChanged, this, [this] {
        clampIndex();
        emit nowPlayingChanged();
    });
}

bool PlaybackController::hasTrack() const
{
    return m_library && !m_library->isEmpty();
}

QString PlaybackController::title() const
{
    return hasTrack() ? m_library->at(m_index).title : QString();
}

QString PlaybackController::artist() const
{
    return hasTrack() ? m_library->at(m_index).artist : QString();
}

int PlaybackController::duration() const
{
    return hasTrack() ? m_library->at(m_index).duration : 0;
}

int PlaybackController::seed() const
{
    return hasTrack() ? m_library->at(m_index).seed : 0;
}

void PlaybackController::clampIndex()
{
    if (!m_library || m_library->isEmpty()) {
        m_index = 0;
        return;
    }
    if (m_index >= m_library->rowCount())
        m_index = m_library->rowCount() - 1;
    if (m_index < 0)
        m_index = 0;
}

void PlaybackController::setVolume(int v)
{
    v = qBound(0, v, 100);
    if (v == m_volume)
        return;
    m_volume = v;
    emit volumeChanged();
}

void PlaybackController::setSource(const QString &s)
{
    if (s == m_source)
        return;
    m_source = s;
    emit sourceChanged();
    emit toast(QStringLiteral("Source: <b>%1</b>").arg(s), false);
}

void PlaybackController::playPause()
{
    if (!hasTrack())
        return;
    m_playing = !m_playing;
    emit playingChanged();
}

void PlaybackController::next()
{
    if (!hasTrack())
        return;
    if (m_shuffle && m_library->rowCount() > 1) {
        int n = m_index;
        while (n == m_index)
            n = QRandomGenerator::global()->bounded(m_library->rowCount());
        m_index = n;
    } else {
        m_index = (m_index + 1) % m_library->rowCount();
    }
    m_position = 0;
    m_playing = true;
    emit nowPlayingChanged();
    emit positionChanged();
    emit playingChanged();
}

void PlaybackController::prev()
{
    if (!hasTrack())
        return;
    // First press restarts the track; a second (within 4s) steps back.
    if (m_position > 4) {
        m_position = 0;
    } else {
        m_index = (m_index - 1 + m_library->rowCount()) % m_library->rowCount();
        m_position = 0;
    }
    m_playing = true;
    emit nowPlayingChanged();
    emit positionChanged();
    emit playingChanged();
}

void PlaybackController::toggleShuffle()
{
    m_shuffle = !m_shuffle;
    emit modesChanged();
    emit toast(m_shuffle ? QStringLiteral("Shuffle on") : QStringLiteral("Shuffle off"), false);
}

void PlaybackController::toggleRepeat()
{
    m_repeat = !m_repeat;
    emit modesChanged();
    emit toast(m_repeat ? QStringLiteral("Repeat on") : QStringLiteral("Repeat off"), false);
}

void PlaybackController::playAt(int row)
{
    if (!m_library || row < 0 || row >= m_library->rowCount())
        return;
    m_index = row;
    m_position = 0;
    m_playing = true;
    emit nowPlayingChanged();
    emit positionChanged();
    emit playingChanged();
}

void PlaybackController::seekFraction(qreal frac)
{
    if (!hasTrack())
        return;
    frac = qBound<qreal>(0.0, frac, 1.0);
    m_position = int(frac * duration());
    emit positionChanged();
}

void PlaybackController::deleteAt(int row)
{
    if (!m_library || row < 0 || row >= m_library->rowCount())
        return;
    const QString gone = m_library->removeAt(row);
    // MediaModel::countChanged already re-clamps the index and re-emits
    // nowPlayingChanged. Just stop if the drive is now empty and announce it.
    if (m_library->isEmpty()) {
        m_playing = false;
        emit playingChanged();
    }
    emit toast(QStringLiteral("Removed <b>%1</b> — see? A delete button. "
                              "Was that so hard?").arg(gone), true);
}

void PlaybackController::deleteCurrent()
{
    deleteAt(m_index);
}

void PlaybackController::tick()
{
    if (!m_playing || !hasTrack())
        return;

    m_position += 1;
    if (m_position >= duration()) {
        m_position = 0;
        if (!m_repeat) {
            m_index = (m_index + 1) % m_library->rowCount();
            emit nowPlayingChanged();
        }
    }
    emit positionChanged();
}
