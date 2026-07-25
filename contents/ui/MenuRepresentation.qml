/*
 * SPDX-FileCopyrightText: 2014 Weng Xuetian <wengxt@gmail.com>
 * SPDX-FileCopyrightText: 2013-2017 Eike Hein <hein@kde.org>
 * SPDX-FileCopyrightText: 2021 Prateek SU <pankajsunal123@gmail.com>
 * SPDX-FileCopyrightText: 2022 Friedrich Schriewer <friedrich.schriewer@gmx.net>
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQml

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmaCore.Dialog {
    id: root

    objectName: "popupWindow"
    flags: Qt.WindowStaysOnTopHint

    location: Plasmoid.configuration.floating || Plasmoid.configuration.launcherPosition == 2 ? "Floating" : Plasmoid.location
    hideOnWindowDeactivate: true

    Plasmoid.status: root.visible ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

    property int iconSize: { 
      switch(Plasmoid.configuration.appsIconSize){
        case 0: return Kirigami.Units.iconSizes.smallMedium;
        case 1: return Kirigami.Units.iconSizes.medium;
        case 2: return Kirigami.Units.iconSizes.large;
        case 3: return Kirigami.Units.iconSizes.huge;
        default: return 80
      }
    }

    property int cellSizeHeight: iconSize
                                     + (Plasmoid.configuration.showAppLabels ? Kirigami.Units.gridUnit * 2 : 0)
                                     + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                                                     highlightItemSvg.margins.left + highlightItemSvg.margins.right))
    property int cellSizeWidth: cellSizeHeight //+ Kirigami.Units.gridUnit
    
    property int rows: Plasmoid.configuration.numberOfRows
    
    onVisibleChanged: {
        if (!visible) {
            reset();
        } else {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
            requestActivate();
        }
    }

    onHeightChanged: {
        var pos = popupPosition(width, height);
        x = pos.x;
        y = pos.y;
    }

    onWidthChanged: {
        var pos = popupPosition(width, height);
        x = pos.x;
        y = pos.y;
    }

    function toggle() {
      root.visible = false;
    }

    function reset() {
        main.reset()
    }

    function popupPosition(width, height) {
        var screenAvail = Plasmoid.availableScreenRect;
        var screen/*Geom*/ = kicker.screenGeometry;
        //QtBug - QTBUG-64115
        /*var screen = Qt.rect(screenAvail.x + screenGeom.x,
            screenAvail.y + screenGeom.y,
            screenAvail.width,
            screenAvail.height);*/

        var offset = 0

        if (Plasmoid.configuration.offsetX > 0 && Plasmoid.configuration.floating) {
          offset = Plasmoid.configuration.offsetX
        } else {
          offset = plasmoid.configuration.floating ? parent.height * 0.35 : 0
        }
        // Fall back to bottom-left of screen area when the applet is on the desktop or floating.
        var x = offset;
        var y = screen.height - height - offset;
        var horizMidPoint = screen.x + (screen.width / 2);
        var vertMidPoint = screen.y + (screen.height / 2);
        var appletTopLeft = parent.mapToGlobal(0, 0);
        var appletBottomLeft = parent.mapToGlobal(0, parent.height);

        if (Plasmoid.configuration.launcherPosition != 0){
          x = horizMidPoint - width / 2;
        } else {
          x = (appletTopLeft.x < horizMidPoint) ? screen.x : (screen.x + screen.width) - width;
          if (Plasmoid.configuration.floating) {
            if (appletTopLeft.x < horizMidPoint) {
              x += offset
            } else if (appletTopLeft.x + width > horizMidPoint){
              x -= offset
            }
          }
        }

        if (Plasmoid.configuration.launcherPosition != 2){
          if (Plasmoid.location == PlasmaCore.Types.TopEdge) {
            if (Plasmoid.configuration.floating) {
                          /*this is floatingAvatar.width*/
              if (Plasmoid.configuration.offsetY > 0) {
                offset = (125 * 1) / 2 + Plasmoid.configuration.offsetY
              } else {
                offset = (125 * 1) / 2 + parent.height * 0.125
              }
            }
            y = screen.y + parent.height + panelSvg.margins.bottom + offset;
          } else {
            if (Plasmoid.configuration.offsetY > 0) {
              offset = Plasmoid.configuration.offsetY
            }
            y = screen.y + screen.height - parent.height - height - panelSvg.margins.top - offset * 2.5;
          }
        } else {
          y = vertMidPoint - height / 2
        }

        return Qt.point(x, y);
    }

    FocusScope {
        id: fs
        focus: true
        Layout.minimumWidth:  (root.cellSizeWidth * Plasmoid.configuration.numberColumns) + scrollBarMetrics.width + innerPadding*2
        Layout.minimumHeight: main.headerLabelRow.height
                              + main.searchBar.height
                              + main.contentY.y
                              + main.itemSpacing * 3
                              + root.cellSizeHeight * rows
                              + innerPadding / 2
        Layout.maximumWidth: Layout.minimumWidth
        Layout.maximumHeight: Layout.minimumHeight
        
        // We want the MainView to have an uniform margin through different plasma themes
        property real innerPadding: 15 

        Item {
          id: mainItem
          x: - dialogSvg.margins.left
          y: - dialogSvg.margins.top
          width: parent.width + dialogSvg.margins.left + dialogSvg.margins.right
          height: parent.height + dialogSvg.margins.top + dialogSvg.margins.bottom

          MainView {
            id: main
            
            anchors.fill: parent
            anchors.margins: fs.innerPadding
          }
        }

        Keys.onPressed: event => {
            if (event.key == Qt.Key_Escape) {
                root.visible = false;
            }
        }
    }

    Component.onCompleted: {
        kicker.reset.connect(reset);
       // windowSystem.hidden.connect(reset);
        rootModel.refresh();
    }
}
