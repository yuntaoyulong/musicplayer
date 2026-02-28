#pragma once

#include <QAbstractListModel>
#include <QUrl>
#include <QString>
#include <QVector>

struct PlaylistEntry {
    QString title;
    QUrl url;
};

class PlaylistModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        UrlRole,
        CurrentRole
    };

    explicit PlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void appendFile(const QUrl &url);
    Q_INVOKABLE void appendFiles(const QList<QUrl> &urls);
    Q_INVOKABLE void removeAt(int index);
    Q_INVOKABLE void clear();

    int currentIndex() const;
    void setCurrentIndex(int index);

    PlaylistEntry at(int index) const;
    bool isEmpty() const;

private:
    static QString prettyTitleFromUrl(const QUrl &url);

    QVector<PlaylistEntry> m_entries;
    int m_currentIndex = -1;
};
