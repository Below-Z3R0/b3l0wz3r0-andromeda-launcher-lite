/*
 * SPDX-FileCopyrightText: 2022 Friedrich Schriewer <friedrich.schriewer@gmx.net>
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components 3.0 as PlasmaComponents

import org.kde.kirigami as Kirigami


RowLayout {
  id: allApps

  spacing: 0

  property QtObject allAppsModel: rootModel.modelForRow(2)

  property var currentStateIndex: plasmoid.configuration.defaultPage

  property bool showItemsInGrid: plasmoid.configuration.showItemsInGrid

  property Component preferredAppsViewComponent: showItemsInGrid ? applicationsGridViewComponent : applicationsListViewComponent

  property alias viewItem: appViewLoader.item

  // Cache: built once on Component.onCompleted and on rootModel changes
  // (upstream re-evaluated on every access). b3l0wz3r0 fork optimization.
  property var appsCategoriesList: []
  property bool _categoriesLoaded: false

  function _buildCategoriesList() {
      var categories = [];
      var categoryName;
      var categoryIcon;

      for (var i = 2; i < rootModel.count; i++) {
        categoryName  = rootModel.data(rootModel.index(i, 0), Qt.DisplayRole);
        categoryIcon  = rootModel.data(rootModel.index(i, 0), Qt.DecorationRole);
        if (!categoryName || categoryName === "") continue;
        if (categoryName === "All Applications") categoryName = i18n("All Apps");
        categories.push({
          name: categoryName,
          index: i,
          icon: categoryIcon
        });
      }
      appsCategoriesList = categories;
      _categoriesLoaded = true;
  }


  Component.onCompleted: _buildCategoriesList()

  function updateModels() {
      allApps.allAppsModel = rootModel.modelForRow(2)
  }

  function updateShowedModel(index){
    viewItem.model = rootModel.modelForRow(index);
    viewItem.currentIndex = 0;
  }

  function incrementCurrentStateIndex() {
    currentStateIndex +=1;
    if (currentStateIndex > appsCategoriesList.length - 1) {
        currentStateIndex = 0;
    }
  }

  function decrementCurrentStateIndex() {
    currentStateIndex -=1;
    if (currentStateIndex < 0) {
      currentStateIndex = appsCategoriesList.length - 1;
    }
  }

  function resetCurrentStateIndex() {
    currentStateIndex = plasmoid.configuration.defaultPage;
  }

  function getCurrentCategory(){
    return appsCategoriesList[currentStateIndex];
  }

  function reset(){
    currentStateIndex = plasmoid.configuration.defaultPage
  }

  Connections {
      target: root
      function onVisibleChanged() {
        currentStateIndex = plasmoid.configuration.defaultPage
      }
  }

  // ── SIDEBAR: Category list ──
  ListView {
    id: categorySidebar
    visible: appsCategoriesList.length > 0
    Layout.preferredWidth: 130
    Layout.fillHeight: true
    clip: true
    model: appsCategoriesList
    reuseItems: true

    delegate: Item {
      width: ListView.view.width
      height: 36

      Rectangle {
        anchors.fill: parent
        color: (allApps.currentStateIndex === index) ? main.contrastBgColor : "transparent"
        radius: 6
        anchors.margins: 2
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 6

        Kirigami.Icon {
          source: modelData.icon
          Layout.preferredWidth: 16
          Layout.preferredHeight: 16
          isMask: true
          color: main.textColor
        }

        PlasmaComponents.Label {
          text: modelData.name
          font.family: main.textFont
          font.pointSize: main.textSize
          color: main.textColor
          elide: Text.ElideRight
          Layout.fillWidth: true
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
          allApps.currentStateIndex = index;
          allApps.updateShowedModel(modelData.index);
        }
      }
    }
  }

  // ── SEPARATOR ──
  Rectangle {
    visible: appsCategoriesList.length > 0
    Layout.preferredWidth: 1
    Layout.fillHeight: true
    color: main.contrastBgColor
  }

  // ── CONTENT: App grid/list ──
  Loader {
    id: appViewLoader
    Layout.fillWidth: true
    Layout.fillHeight: true
    sourceComponent: preferredAppsViewComponent
    active: true
  }

  Component {
    id: applicationsListViewComponent
    AppListView {
      id: appList

      anchors.fill: parent
      showSectionSeparator: false
      model: allAppsModel
    }
  }

  Component {
    id: applicationsGridViewComponent

    AppGridView {
      id: grid
      anchors.fill: parent
      model: allAppsModel
    }
  }
}
