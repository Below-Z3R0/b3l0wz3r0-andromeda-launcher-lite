/*
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import org.kde.plasma.core as PlasmaCore

PlasmaCore.Dialog {
  id: avatarContainer

  property int avatarWidth
  property bool isTop: false

  type: PlasmaCore.Dialog.Notification

  x: root.x + root.width / 2 - width / 2
  y: root.y - width / 2

  mainItem:
  Item {
    onParentChanged: {
      if (parent) {
        var popupWindow = Window.window
        if (typeof popupWindow.backgroundHints !== "undefined") {
          popupWindow.backgroundHints = PlasmaCore.Types.NoBackground
        }
      }
    }
  }
  UserAvatar {
    id: avatarFrame
    anchors.centerIn: parent
    width: avatarWidth
    height: avatarWidth
  }
}
