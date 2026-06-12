/*
 * Copyright 2026  Petar Nedyalkov
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 */

import QtQuick
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Item {
    id: compactRepresentation

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    TrayCompactView {
        id: compactItemInTray
        anchors.fill: parent
        weatherRoot: root
    }

    // ──────────────────────────────────────────────────────────────
    //  RICH TOOLTIP FOR SYSTEM TRAY (same as panel)
    // ──────────────────────────────────────────────────────────────
    PlasmaCore.ToolTipArea {
        id: trayToolTip
        anchors.fill: parent

        mainItem: TooltipContent {
            weatherRoot: compactItemInTray.weatherRoot
        }
    }
}