/*
    SPDX-FileCopyrightText: 2026 Barq OS contributors
    SPDX-License-Identifier: Apache-2.0
*/

import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: root
    color: "#050814"

    property int stage: 0

    Image {
        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        source: "file:///usr/share/wallpapers/Barq/contents/images/3840x2160.png"
    }

    Column {
        anchors.centerIn: parent
        spacing: Kirigami.Units.gridUnit * 1.5

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#EAF2FF"
            font.family: "Inter"
            font.pixelSize: Math.max(Kirigami.Units.gridUnit * 2.2, 34)
            font.weight: Font.DemiBold
            text: "Barq OS"
            textFormat: Text.PlainText
        }

        Rectangle {
            width: Math.min(root.width * 0.22, Kirigami.Units.gridUnit * 22)
            height: Math.max(3, Kirigami.Units.smallSpacing / 2)
            color: "#0B1220"
            radius: height / 2

            Rectangle {
                height: parent.height
                width: parent.width * Math.max(0.08, Math.min(root.stage / 5, 1))
                color: "#1A7BFF"
                radius: height / 2

                Behavior on width {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    opacity: 0
    Component.onCompleted: intro.start()

    NumberAnimation {
        id: intro
        target: root
        property: "opacity"
        from: 0
        to: 1
        duration: 260
        easing.type: Easing.OutCubic
    }
}
