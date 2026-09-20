#include "mediamodel.h"

MediaModel::MediaModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // The same seed library the web preview ships, so every stack tells the
    // same story: the seventh track ("Thumb Drive Symphony") is the one people
    // delete in the demo.
    m_tracks = {
        {QStringLiteral("Cold Start"),               QStringLiteral("Idle Hands"),    222, 1},
        {QStringLiteral("Amber Cluster"),            QStringLiteral("Nightdrive"),    255, 2},
        {QStringLiteral("Other Side of the Pillow"), QStringLiteral("Kova"),          178, 3},
        {QStringLiteral("Thumb Drive Symphony"),     QStringLiteral("USB 1"),         320, 4},
        {QStringLiteral("Delete Button"),            QStringLiteral("The Engineers"), 187, 5},
        {QStringLiteral("Ham Radio Heartbreak"),     QStringLiteral("Clusterfunk"),   231, 6},
        {QStringLiteral("DIN Mount Blues"),          QStringLiteral("Scary Side"),    242, 7},
    };
}

int MediaModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_tracks.size();
}

QVariant MediaModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_tracks.size())
        return {};

    const Track &t = m_tracks.at(index.row());
    switch (role) {
    case TitleRole:    return t.title;
    case ArtistRole:   return t.artist;
    case DurationRole: return t.duration;
    case SeedRole:     return t.seed;
    default:           return {};
    }
}

QHash<int, QByteArray> MediaModel::roleNames() const
{
    return {
        {TitleRole,    "title"},
        {ArtistRole,   "artist"},
        {DurationRole, "duration"},
        {SeedRole,     "seed"},
    };
}

QString MediaModel::removeAt(int row)
{
    if (row < 0 || row >= m_tracks.size())
        return {};

    const QString title = m_tracks.at(row).title;
    beginRemoveRows(QModelIndex(), row, row);
    m_tracks.remove(row);
    endRemoveRows();
    emit countChanged();
    return title;
}
