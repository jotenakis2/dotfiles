var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
                {
                    "config": {
                        "/": {
                            "UserBackgroundHints": "ShadowBackground"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/Units": {
                            "pressureUnit": "5022",
                            "speedUnit": "9001"
                        },
                        "/WeatherStation": {
                            "placeDisplayName": "Ouistreham, France, FR",
                            "placeInfo": "Ouistreham, France, FR|2989013",
                            "provider": "bbcukmet"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.weather",
                    "title": "Bulletin météo"
                }
            ],
            "config": {
                "/": {
                    "ItemGeometries-1920x1080": "Applet-33:1232,0,688,368,0;",
                    "ItemGeometriesHorizontal": "Applet-33:1232,0,688,368,0;",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.potd"
                },
                "/ConfigDialog": {
                    "DialogHeight": "1004",
                    "DialogWidth": "1920"
                },
                "/General": {
                    "positions": "{\"1920x1080\":[]}"
                },
                "/Wallpaper/com.plasma.wallpaper.wallhaven/General": {
                    "CategoryAnime": "false",
                    "CategoryPeople": "false",
                    "ErrorNotification": "false",
                    "FillMode": "2",
                    "PuritySFW": "false",
                    "Query": "landscape, mountains, rivers, snow",
                    "RefreshNotification": "false",
                    "RetryRequestCount": "10",
                    "RetryRequestDelay": "10",
                    "TopRange": "1y",
                    "WallpaperDelay": "30",
                    "currentWallpaperThumbnail": "https://th.wallhaven.cc/small/nr/nr62l1.jpg"
                },
                "/Wallpaper/kde.wallhaven.wallpaper/General": {
                    "categories": "custom",
                    "forzeUpdate": "2"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "file:///home/mbanjieu/.local/share/wallpapers/SpacePlasma.jpg"
                },
                "/Wallpaper/org.kde.potd/General": {
                    "FillMode": "1",
                    "Provider": "bing"
                }
            },
            "wallpaperPlugin": "org.kde.potd"
        }
    ],
    "panels": [
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/": {
                            "popupHeight": "580",
                            "popupWidth": "1625"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "alphaSort": "true",
                            "favoritesPortedToKAstats": "true",
                            "highlightNewlyInstalledApps": "false",
                            "icon": "start-here-fedora",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.pager"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "groupingAppIdBlacklist": "Alacritty.desktop,kitty.desktop,footclient.desktop,com.mitchellh.ghostty.desktop,helium.desktop,org.kde.konsole.desktop,org.mozilla.firefox.desktop,virt-manager.desktop,foot.desktop",
                            "groupingLauncherUrlBlacklist": "applications:footclient.desktop,applications:org.mozilla.firefox.desktop,applications:Alacritty.desktop,applications:helium.desktop,applications:com.mitchellh.ghostty.desktop,applications:org.kde.konsole.desktop,applications:virt-manager.desktop,applications:kitty.desktop,applications:foot.desktop",
                            "iconSpacing": "3",
                            "indicateAudioStreams": "false",
                            "launchers": "applications:systemsettings.desktop,applications:org.kde.konsole.desktop,applications:helium.desktop,applications:org.mozilla.firefox.desktop,applications:org.kde.kate.desktop,preferred://filemanager,applications:io.github.forkgram.tdesktop.desktop,applications:org.kde.konversation.desktop,applications:virt-manager.desktop,applications:vesktop.desktop,applications:com.ktechpit.whatsie.desktop,applications:org.kde.neochat.desktop,applications:X.desktop,applications:org.kde.plasma-systemmonitor.desktop,applications:org.qbittorrent.qBittorrent.desktop,applications:iptvnator.desktop",
                            "showToolTips": "false",
                            "tooltipControls": "false"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "247",
                            "popupWidth": "305"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.linechart",
                            "showTitle": "true",
                            "title": "CPU",
                            "updateRateLimit": "2000"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "cpu/all/usage": "110,85,171",
                            "gpu/gpu1/usage": "85,85,255",
                            "gpu/gpu\\d+/usage": "116,171,85"
                        },
                        "/SensorLabels": {
                            "cpu/all/usage": "CPU",
                            "gpu/gpu1/usage": "GPU"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"cpu/all/usage\",\"gpu/gpu\\\\d+/usage\"]",
                            "lowPrioritySensorIds": "[\"cpu/all/cpuCount\",\"cpu/all/coreCount\"]",
                            "totalSensors": "[\"cpu/all/usage\"]"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor.cpu"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false",
                            "length": "20"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "184",
                            "popupWidth": "350"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.linechart",
                            "title": "RAM",
                            "updateRateLimit": "0"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "memory/physical/used": "110,85,171"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"memory/physical/used\"]",
                            "lowPrioritySensorIds": "[\"memory/physical/total\"]",
                            "totalSensors": "[\"memory/physical/usedPercent\"]"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor.memory"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false",
                            "length": "20"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "210",
                            "popupWidth": "269"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.linechart",
                            "title": "NET",
                            "updateRateLimit": "2000"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "network/all/download": "110,85,171",
                            "network/all/upload": "146,171,85"
                        },
                        "/SensorLabels": {
                            "network/all/download": "Réception",
                            "network/all/upload": "Envoi"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"network/all/download\",\"network/all/upload\"]"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor.net"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false",
                            "length": "20"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "449",
                            "popupWidth": "678"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.linechart",
                            "showTitle": "true",
                            "title": "NVMe",
                            "updateRateLimit": "4000"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "disk/all/read": "146,171,85",
                            "disk/all/write": "110,85,171"
                        },
                        "/SensorLabels": {
                            "disk/a8ebe179-16eb-4bff-a831-ec8f35463e6e/freePercent": "Free%",
                            "disk/all/read": "Lecture",
                            "disk/all/write": "Écriture"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"disk/all/write\",\"disk/all/read\"]",
                            "lowPrioritySensorIds": "[\"disk/nvme0n1/total\",\"disk/(?!all).*/freePercent\"]"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor.diskactivity"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false",
                            "length": "20"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "400",
                            "popupWidth": "560"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.linechart",
                            "title": "TEMP",
                            "updateRateLimit": "2000"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "lmsensors/acpitz-acpi-0/temp1": "0,0,127",
                            "lmsensors/acpitz-acpi-0/temp2": "170,0,127",
                            "lmsensors/acpitz-acpi-0/temp3": "171,105,85",
                            "lmsensors/acpitz-acpi-0/temp4": "85,171,89",
                            "lmsensors/acpitz-acpi-0/temp5": "171,111,85",
                            "lmsensors/ath11k_hwmon-pci-0200/temp1": "0,170,127",
                            "lmsensors/nvme-pci-0400/temp1": "170,85,127"
                        },
                        "/SensorLabels": {
                            "lmsensors/acpitz-acpi-0/temp1": "CPU",
                            "lmsensors/acpitz-acpi-0/temp2": "2",
                            "lmsensors/acpitz-acpi-0/temp3": "3",
                            "lmsensors/acpitz-acpi-0/temp4": "4",
                            "lmsensors/acpitz-acpi-0/temp5": "5",
                            "lmsensors/ath11k_hwmon-pci-0200/temp1": "Wifi",
                            "lmsensors/nvme-pci-0400/temp1": "NVMe"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"lmsensors/acpitz-acpi-0/temp1\",\"lmsensors/ath11k_hwmon-pci-0200/temp1\",\"lmsensors/nvme-pci-0400/temp1\"]",
                            "lowPrioritySensorIds": "[]"
                        },
                        "/org.kde.ksysguard.linechart/General": {
                            "historyAmount": "600",
                            "rangeAutoY": "false",
                            "rangeFromY": "20",
                            "rangeToY": "90"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false",
                            "length": "40"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "338",
                            "popupWidth": "337"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/WeatherStation": {
                            "placeDisplayName": "Ouistreham, France, FR",
                            "placeInfo": "Ouistreham, France, FR|2989013",
                            "provider": "bbcukmet"
                        }
                    },
                    "plugin": "org.kde.plasma.weather"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "451",
                            "popupWidth": "560"
                        },
                        "/Appearance": {
                            "fontWeight": "400",
                            "showDate": "false"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.showdesktop"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 3.111111111111111,
            "hiding": "normal",
            "location": "top",
            "maximumLength": 77.33333333333333,
            "minimumLength": 72.5,
            "offset": 0
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
