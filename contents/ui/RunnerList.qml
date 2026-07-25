/*
 * SPDX-FileCopyrightText: 2022 Friedrich Schriewer <friedrich.schriewer@gmx.net>
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras

import org.kde.plasma.private.kicker 0.1 as Kicker

import QtQuick.Window 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.kirigami as Kirigami

AppListView {
  id: searchList

  property alias viewItem: searchList

  Loader {
    anchors.fill: parent
    width: searchList.width - (Kirigami.Units.gridUnit * 4)

    active: searchList.count === 0
    visible: active
    asynchronous: true

    sourceComponent: PlasmaExtras.PlaceholderMessage {
      id: emptyHint

      iconName: "edit-none"
      opacity: 0
      text: i18nc("@info:status", "No matches")

      Connections {
        target: runnerModel
        function onQueryFinished() {
          showAnimation.restart()
        }
      }

      NumberAnimation {
        id: showAnimation
        duration: Kirigami.Units.longDuration
        easing.type: Easing.OutCubic
        property: "opacity"
        target: emptyHint
        to: 1
      }
    }
  }

  Connections {
    target: runnerModel
    function onQueryChanged() { 
      searchList.blockingHoverFocus = true;
      searchList.interceptedPosition = null;
      searchList.currentIndex = 0;
    }
  }
}