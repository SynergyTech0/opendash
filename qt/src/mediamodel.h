#pragma once

#include <QAbstractListModel>
#include <QVector>

// A track on the "thumb drive". Plain value type; the model owns the list.
struct Track {
    QString title;
    QString artist;
    int duration = 0;   // seconds
    int seed = 0;       // drives the generated album-art gradient
};

// The USB library, exposed to QML as a real list model. This is what backs the
// delete button: removing a row is a genuine model mutation, not a view trick.
class MediaModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    // Total "used" bytes, purely cosmetic (7.4 MB per track, like the mockup).
    Q_PROPERTY(double usedMb READ usedMb NOTIFY countChanged)

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        ArtistRole,
        DurationRole,
        SeedRole
    };
    Q_ENUM(Roles)

    explicit MediaModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    double usedMb() const { return m_tracks.size() * 7.4; }

    // Accessors used by the playback controller.
    const Track &at(int i) const { return m_tracks.at(i); }
    bool isEmpty() const { return m_tracks.isEmpty(); }

    // Remove a track and report its title so the toast can name it.
    // Returns an empty string if the index was out of range.
    QString removeAt(int row);

signals:
    void countChanged();

private:
    QVector<Track> m_tracks;
};
