#pragma once

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QSettings>
#include <QUrl>

#include "playlistmodel.h"

class PlayerController : public QObject {
    Q_OBJECT
    Q_PROPERTY(PlaylistModel *playlist READ playlist CONSTANT)
    Q_PROPERTY(QString nowPlayingTitle READ nowPlayingTitle NOTIFY nowPlayingChanged)
    Q_PROPERTY(QString nowPlayingPath READ nowPlayingPath NOTIFY nowPlayingChanged)
    Q_PROPERTY(QMediaPlayer *mediaPlayer READ mediaPlayer CONSTANT)
    Q_PROPERTY(QAudioOutput *audioOutput READ audioOutput CONSTANT)
    Q_PROPERTY(QStringList recentItems READ recentItems NOTIFY recentItemsChanged)

public:
    explicit PlayerController(QObject *parent = nullptr);

    PlaylistModel *playlist();
    QMediaPlayer *mediaPlayer();
    QAudioOutput *audioOutput();

    QString nowPlayingTitle() const;
    QString nowPlayingPath() const;
    QStringList recentItems() const;

    Q_INVOKABLE void openFiles();
    Q_INVOKABLE void addFiles(const QList<QUrl> &urls);
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void playAt(int index);
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void seek(qint64 position);
    Q_INVOKABLE void setVolume(double volume);
    Q_INVOKABLE void playRecent(int index);

signals:
    void nowPlayingChanged();
    void recentItemsChanged();
    void openFilesRequested();

private:
    void setCurrentTrack(int index, bool autoplay = true);
    void appendToRecent(const QUrl &url);
    void loadRecent();
    void saveRecent();

    PlaylistModel m_playlist;
    QMediaPlayer m_player;
    QAudioOutput m_audio;
    QStringList m_recent;
    QSettings m_settings;
};
