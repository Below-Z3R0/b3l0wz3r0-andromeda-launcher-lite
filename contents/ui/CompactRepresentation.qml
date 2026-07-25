/*
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

import org.kde.kirigami as Kirigami

Item {
    id: root

    property QtObject dashWindow: null
    readonly property bool useCustomButtonImage: (Plasmoid.configuration.useCustomButtonImage && Plasmoid.configuration.customButtonImage.length != 0)

    Kirigami.Icon {
        HoverHandler { enabled: false }
        id: buttonIcon

        width: Plasmoid.configuration.activationIndicator ? parent.width * 0.65 : parent.width
        height: Plasmoid.configuration.activationIndicator ? parent.height * 0.65 : parent.height
        anchors.centerIn: parent

        source: useCustomButtonImage ? Plasmoid.configuration.customButtonImage : Plasmoid.configuration.icon

        active: mouseArea.containsMouse

        smooth: true

        Rectangle {
          id: indicator
          width: 0
          anchors.horizontalCenter: parent.horizontalCenter
          height: 3 * 1
          radius: 10
          y: parent.height + height
          color: Plasmoid.configuration.indicatorColor
          visible: Plasmoid.configuration.activationIndicator

          states: [
            State { name: "inactive"
            when: !dashWindow.visible
            PropertyChanges {
                target: indicator
                width: 0

              }
            },
            State { name: "active"
            when: dashWindow.visible
            PropertyChanges {
                target: indicator
                width: parent.width * 0.65
              }
            }
          ]
          transitions: [
            Transition {
              NumberAnimation { properties: 'width'; duration: 60}
            }
          ]
        }
    }

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        onClicked: {
            dashWindow.visible = !dashWindow.visible;
        }
    }

    Component.onCompleted: {
        dashWindow = Qt.createQmlObject("MenuRepresentation { visible: false }", root);
        plasmoid.activated.connect(function() {
            dashWindow.visible = !dashWindow.visible;
        });
    }
}
