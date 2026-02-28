import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtCore
import QtMultimedia
import MistPlayer 1.0
import "components"

ApplicationWindow {
    id: window

    width: 1240
    height: 780
    minimumWidth: 980
    minimumHeight: 620
    visible: true
    title: "MistPlayer"
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    readonly property bool themeReady: typeof Theme !== "undefined" && Theme !== null
    readonly property var themeObj: themeReady ? Theme : null
    readonly property var media: playerController && playerController.mediaPlayer ? playerController.mediaPlayer : null
    readonly property var audio: playerController && playerController.audioOutput ? playerController.audioOutput : null

    readonly property int sXS: themeObj ? themeObj.spaceXS : 8
    readonly property int sS: themeObj ? themeObj.spaceS : 12
    readonly property int sM: themeObj ? themeObj.spaceM : 18
    readonly property int sL: themeObj ? themeObj.spaceL : 26
    readonly property int sXL: themeObj ? themeObj.spaceXL : 36
    readonly property int sXXL: themeObj ? themeObj.spaceXXL : 52

    readonly property int rWindow: themeObj ? themeObj.radiusWindow : 30
    readonly property int rPanel: themeObj ? themeObj.radiusPanel : 24
    readonly property int bodySize: themeObj ? themeObj.body : 15
    readonly property int captionSize: themeObj ? themeObj.caption : 12
    readonly property int titleSize: themeObj ? themeObj.title : 22
    readonly property int headlineSize: themeObj ? themeObj.headline : 38

    readonly property color textPrimary: themeObj ? themeObj.textPrimary : "#1D252C"
    readonly property color textSecondary: themeObj ? themeObj.textSecondary : "#67727D"
    readonly property color lineCool: themeObj ? themeObj.lineCool : "#1F2C3844"

    property bool showQueue: true

    function iconPath(name) {
        if (themeObj && themeObj.icon)
            return themeObj.icon(name)
        return "qrc:/qt/qml/MistPlayer/assets/icons/" + name + ".svg"
    }

    function formatTime(ms) {
        const total = Math.max(0, Math.floor((ms || 0) / 1000))
        const h = Math.floor(total / 3600)
        const m = Math.floor((total % 3600) / 60)
        const s = total % 60
        if (h > 0)
            return h + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s)
        return m + ":" + (s < 10 ? "0" + s : s)
    }

    Rectangle {
        anchors.fill: parent
        radius: rWindow
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0; color: Qt.rgba(0.99, 0.99, 1.0, 0.82) }
            GradientStop { position: 1; color: Qt.rgba(0.95, 0.97, 0.98, 0.72) }
        }
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.35)

        DropArea {
            anchors.fill: parent
            onDropped: function(drop) {
                const files = []
                for (let i = 0; i < drop.urls.length; ++i)
                    files.push(drop.urls[i])
                playerController.addFiles(files)
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: sXL
            spacing: sL

            GlassPanel {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(640, window.width * 0.66)
                tint: Qt.rgba(1, 1, 1, 0.56)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: sXL
                    spacing: sL

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: "MistPlayer"
                                font.pixelSize: titleSize
                                font.weight: Font.Medium
                                color: textPrimary
                            }
                            Text {
                                text: "雾白、安静、专注于播放"
                                font.pixelSize: captionSize
                                color: textSecondary
                            }
                        }

                        Item { Layout.fillWidth: true }

                        ControlButton {
                            iconSource: iconPath("open")
                            onClicked: playerController.openFiles()
                            ToolTip.visible: hovered
                            ToolTip.text: "打开媒体文件"
                        }
                    }

                    GlassPanel {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        tint: Qt.rgba(1, 1, 1, 0.42)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: sXXL
                            spacing: sM

                            Text {
                                Layout.fillWidth: true
                                text: playerController.nowPlayingTitle || "Drop media to begin"
                                font.pixelSize: headlineSize
                                font.weight: Font.Medium
                                color: textPrimary
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                text: playerController.nowPlayingPath || "Arch Linux · Wayland ready"
                                font.pixelSize: bodySize
                                color: textSecondary
                                elide: Text.ElideMiddle
                            }

                            Item { Layout.fillHeight: true }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: Math.min(parent.width * 0.58, 320)
                                height: width
                                radius: width * 0.17
                                color: Qt.rgba(1, 1, 1, 0.62)
                                border.width: 1
                                border.color: lineCool

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width * 0.72
                                    height: width
                                    radius: width * 0.16
                                    color: "transparent"
                                    border.color: Qt.rgba(1, 1, 1, 0.55)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: (media && media.hasVideo) ? "VIDEO" : "PLAY"
                                    color: textSecondary
                                    font.pixelSize: captionSize
                                    font.letterSpacing: 8
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    GlassPanel {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 192
                        tint: Qt.rgba(1, 1, 1, 0.66)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: sL
                            spacing: sM

                            TimelineSlider {
                                id: timeline
                                Layout.fillWidth: true
                                from: 0
                                to: Math.max(1, media ? media.duration : 1)
                                value: userDragging ? value : (media ? media.position : 0)
                                onMoved: playerController.seek(value)
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: formatTime(media ? media.position : 0)
                                    color: textSecondary
                                    font.pixelSize: captionSize
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: formatTime(media ? media.duration : 0)
                                    color: textSecondary
                                    font.pixelSize: captionSize
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: sS

                                ControlButton {
                                    iconSource: iconPath("previous")
                                    onClicked: playerController.previous()
                                }
                                ControlButton {
                                    iconSource: (media && media.playbackState === MediaPlayer.PlayingState)
                                                ? iconPath("pause")
                                                : iconPath("play")
                                    onClicked: playerController.playPause()
                                }
                                ControlButton {
                                    iconSource: iconPath("next")
                                    onClicked: playerController.next()
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: "音量"
                                    color: textSecondary
                                    font.pixelSize: captionSize
                                }

                                Slider {
                                    Layout.preferredWidth: 150
                                    from: 0
                                    to: 1
                                    value: audio ? audio.volume : 0.8
                                    onMoved: playerController.setVolume(value)
                                }
                            }
                        }
                    }
                }
            }

            GlassPanel {
                Layout.fillHeight: true
                Layout.fillWidth: true
                tint: Qt.rgba(1, 1, 1, 0.52)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: sL
                    spacing: sM

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "播放队列"
                            color: textPrimary
                            font.pixelSize: bodySize
                            font.weight: Font.Medium
                        }
                        Item { Layout.fillWidth: true }
                        ControlButton {
                            iconSource: iconPath("queue")
                            onClicked: window.showQueue = !window.showQueue
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: showQueue ? Math.max(240, window.height * 0.46) : 0
                        visible: showQueue
                        clip: true
                        spacing: sXS
                        model: playerController.playlist
                        delegate: QueueItem {
                            width: ListView.view.width
                            title: model.title || ""
                            isCurrent: !!model.isCurrent
                            onClicked: playerController.playAt(index)
                        }
                    }

                    GlassPanel {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        tint: Qt.rgba(1, 1, 1, 0.34)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: sM

                            Text {
                                text: "最近打开"
                                font.pixelSize: bodySize
                                color: textSecondary
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: playerController.recentItems
                                delegate: ItemDelegate {
                                    width: ListView.view.width
                                    onClicked: playerController.playRecent(index)

                                    contentItem: Text {
                                        text: modelData || ""
                                        elide: Text.ElideMiddle
                                        color: textPrimary
                                        font.pixelSize: bodySize
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        radius: themeObj ? themeObj.radiusPill : 14
                                        color: hovered ? Qt.rgba(1, 1, 1, 0.64) : "transparent"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "打开媒体文件"
        fileMode: FileDialog.OpenFiles
        currentFolder: {
            const music = StandardPaths.writableLocation(StandardPaths.MusicLocation)
            if (music && music.length > 0)
                return "file://" + music
            const home = StandardPaths.writableLocation(StandardPaths.HomeLocation)
            return "file://" + home
        }
        nameFilters: ["Media files (*.mp3 *.flac *.wav *.ogg *.m4a *.aac *.mp4 *.mkv *.webm *.avi *.mov)", "All files (*)"]
        onAccepted: {
            if (selectedFiles && selectedFiles.length > 0)
                playerController.addFiles(selectedFiles)
        }
    }

    Connections {
        target: playerController
        function onOpenFilesRequested() {
            fileDialog.open()
        }
    }

    Shortcut { sequences: [StandardKey.Open]; onActivated: playerController.openFiles() }
    Shortcut { sequences: ["Space"]; onActivated: playerController.playPause() }
    Shortcut { sequences: ["Ctrl+Right"]; onActivated: playerController.next() }
    Shortcut { sequences: ["Ctrl+Left"]; onActivated: playerController.previous() }
}
