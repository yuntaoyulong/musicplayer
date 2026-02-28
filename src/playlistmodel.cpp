#include "playlistmodel.h"

#include <QFileInfo>

PlaylistModel::PlaylistModel(QObject *parent)
    : QAbstractListModel(parent) {
}

int PlaylistModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return static_cast<int>(m_entries.size());
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= rowCount()) {
        return {};
    }

    const auto &entry = m_entries.at(index.row());
    switch (role) {
    case TitleRole:
        return entry.title;
    case UrlRole:
        return entry.url;
    case CurrentRole:
        return index.row() == m_currentIndex;
    default:
        return {};
    }
}

QHash<int, QByteArray> PlaylistModel::roleNames() const {
    return {
        {TitleRole, "title"},
        {UrlRole, "url"},
        {CurrentRole, "isCurrent"}
    };
}

void PlaylistModel::appendFile(const QUrl &url) {
    if (!url.isValid() || !url.isLocalFile()) {
        return;
    }

    const int pos = rowCount();
    beginInsertRows({}, pos, pos);
    m_entries.push_back({prettyTitleFromUrl(url), url});
    endInsertRows();

    if (m_currentIndex < 0) {
        setCurrentIndex(0);
    }
}

void PlaylistModel::appendFiles(const QList<QUrl> &urls) {
    for (const auto &url : urls) {
        appendFile(url);
    }
}

void PlaylistModel::removeAt(int index) {
    if (index < 0 || index >= rowCount()) {
        return;
    }

    beginRemoveRows({}, index, index);
    m_entries.removeAt(index);
    endRemoveRows();

    if (m_entries.isEmpty()) {
        m_currentIndex = -1;
        return;
    }

    if (m_currentIndex >= rowCount()) {
        setCurrentIndex(rowCount() - 1);
    } else if (m_currentIndex == index) {
        setCurrentIndex(qMin(index, rowCount() - 1));
    } else if (index < m_currentIndex) {
        setCurrentIndex(m_currentIndex - 1);
    }
}

void PlaylistModel::clear() {
    beginResetModel();
    m_entries.clear();
    m_currentIndex = -1;
    endResetModel();
}

int PlaylistModel::currentIndex() const {
    return m_currentIndex;
}

void PlaylistModel::setCurrentIndex(int index) {
    if (index < -1 || index >= rowCount() || index == m_currentIndex) {
        return;
    }

    const int previousIndex = m_currentIndex;
    m_currentIndex = index;

    if (previousIndex >= 0) {
        const QModelIndex changed = this->index(previousIndex);
        emit dataChanged(changed, changed, {CurrentRole});
    }

    if (m_currentIndex >= 0) {
        const QModelIndex changed = this->index(m_currentIndex);
        emit dataChanged(changed, changed, {CurrentRole});
    }
}

PlaylistEntry PlaylistModel::at(int index) const {
    if (index < 0 || index >= rowCount()) {
        return {};
    }
    return m_entries.at(index);
}

bool PlaylistModel::isEmpty() const {
    return m_entries.isEmpty();
}

QString PlaylistModel::prettyTitleFromUrl(const QUrl &url) {
    return QFileInfo(url.toLocalFile()).completeBaseName();
}
