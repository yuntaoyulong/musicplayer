#include "playercontroller.h"


PlayerController::PlayerController(QObject *parent)
    : QObject(parent)
    , m_settings("mistplayer", "mistplayer") {
    m_player.setAudioOutput(&m_audio);
    m_audio.setVolume(0.8);

    connect(&m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::EndOfMedia) {
            next();
        }
    });

    connect(&m_player, &QMediaPlayer::sourceChanged, this, &PlayerController::nowPlayingChanged);

    loadRecent();
}

PlaylistModel *PlayerController::playlist() {
    return &m_playlist;
}

QMediaPlayer *PlayerController::mediaPlayer() {
    return &m_player;
}

QAudioOutput *PlayerController::audioOutput() {
    return &m_audio;
}

QString PlayerController::nowPlayingTitle() const {
    const int index = m_playlist.currentIndex();
    return index >= 0 ? m_playlist.at(index).title : QStringLiteral("Drop media to begin");
}

QString PlayerController::nowPlayingPath() const {
    const int index = m_playlist.currentIndex();
    return index >= 0 ? m_playlist.at(index).url.toLocalFile() : QStringLiteral("Arch Linux · Wayland-ready local playback");
}

QStringList PlayerController::recentItems() const {
    return m_recent;
}

void PlayerController::openFiles() {
    emit openFilesRequested();
}

void PlayerController::addFiles(const QList<QUrl> &urls) {
    if (urls.isEmpty()) {
        return;
    }

    const bool wasEmpty = m_playlist.isEmpty();
    m_playlist.appendFiles(urls);
    for (const auto &url : urls) {
        appendToRecent(url);
    }

    if (wasEmpty) {
        setCurrentTrack(0, true);
    }
}

void PlayerController::playPause() {
    if (m_player.playbackState() == QMediaPlayer::PlayingState) {
        m_player.pause();
    } else {
        if (m_player.source().isEmpty() && !m_playlist.isEmpty()) {
            setCurrentTrack(qMax(0, m_playlist.currentIndex()), false);
        }
        m_player.play();
    }
}

void PlayerController::playAt(int index) {
    setCurrentTrack(index, true);
}

void PlayerController::next() {
    if (m_playlist.isEmpty()) {
        return;
    }
    const int current = qMax(0, m_playlist.currentIndex());
    const int nextIndex = (current + 1) % m_playlist.rowCount();
    setCurrentTrack(nextIndex, true);
}

void PlayerController::previous() {
    if (m_playlist.isEmpty()) {
        return;
    }

    const int current = qMax(0, m_playlist.currentIndex());
    const int previousIndex = (current - 1 + m_playlist.rowCount()) % m_playlist.rowCount();
    setCurrentTrack(previousIndex, true);
}

void PlayerController::seek(qint64 position) {
    m_player.setPosition(position);
}

void PlayerController::setVolume(double volume) {
    m_audio.setVolume(qBound(0.0, volume, 1.0));
}

void PlayerController::playRecent(int index) {
    if (index < 0 || index >= m_recent.size()) {
        return;
    }
    addFiles({QUrl::fromLocalFile(m_recent.at(index))});
    setCurrentTrack(m_playlist.rowCount() - 1, true);
}

void PlayerController::setCurrentTrack(int index, bool autoplay) {
    if (index < 0 || index >= m_playlist.rowCount()) {
        return;
    }

    m_playlist.setCurrentIndex(index);
    const PlaylistEntry entry = m_playlist.at(index);
    m_player.setSource(entry.url);
    emit nowPlayingChanged();

    if (autoplay) {
        m_player.play();
    }
}

void PlayerController::appendToRecent(const QUrl &url) {
    if (!url.isLocalFile()) {
        return;
    }

    const QString localPath = url.toLocalFile();
    m_recent.removeAll(localPath);
    m_recent.prepend(localPath);
    constexpr int maxRecentItems = 12;
    while (m_recent.size() > maxRecentItems) {
        m_recent.removeLast();
    }

    saveRecent();
    emit recentItemsChanged();
}

void PlayerController::loadRecent() {
    m_recent = m_settings.value("recent", QStringList{}).toStringList();
}

void PlayerController::saveRecent() const {
    m_settings.setValue("recent", m_recent);
}
