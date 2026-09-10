+++
title = "Patches Posted For Fixing The Linux DRM Scheduler's Fair Policy"
description = 'Ahead of the Linux 7.2 kernel release expected out on Sunday, the Direct Rendering Manager (DRM) subsystem was forced to revert their "fair" scheduler policy default new for this kernel. Due to a last minute user-reported regression, FIFO returns as the default DRM scheduler poli'
date = "2026-08-14T10:04:16Z"
url = "https://www.phoronix.com/news/Linux-Patches-Fix-DRM-Fair"
author = "Michael Larabel"
text = ""
lastupdated = "2026-08-15T16:25:52.081830947Z"
seen = false
+++

Ahead of the Linux 7.2 kernel release expected out on Sunday, the Direct Rendering Manager (DRM) subsystem was forced to revert their "fair" scheduler policy default new for this kernel. Due to a last minute user-reported regression, FIFO returns as the default DRM scheduler policy for Linux 7.2. But patches are now available for addressing that regression and thus hopefully for Linux 7.3 there will be the fair scheduler becoming the default...