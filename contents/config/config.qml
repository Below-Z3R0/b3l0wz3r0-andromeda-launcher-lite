/*
 * SPDX-FileCopyrightText: 2026 b3l0wz3r0
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15

import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: "preferences-desktop-plasma"
         source: "config/ConfigGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Lists and grids")
        icon: "view-list-details"
        source: "config/ListAndGrid.qml"
    }
}
