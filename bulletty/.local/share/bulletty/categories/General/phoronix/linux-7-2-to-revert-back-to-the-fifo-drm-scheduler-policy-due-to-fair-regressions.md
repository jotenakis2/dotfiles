+++
title = 'Linux 7.2 To Revert Back To The FIFO DRM Scheduler Policy Due To "Fair" Regressions'
description = 'One of the Direct Rendering Manager changes made for Linux 7.2 was switching to "fair" as the DRM scheduler default in place of the existing FIFO policy. The intent was on making the DRM scheduler policy more fair with this being used by AMDGPU and various other DRM kernel graphi'
date = "2026-08-12T10:31:25Z"
url = "https://www.phoronix.com/news/Linux-7.2-Reverting-DRM-Fair"
author = "Michael Larabel"
text = ""
lastupdated = "2026-08-13T22:13:29.205179543Z"
seen = false
+++

One of the Direct Rendering Manager changes made for Linux 7.2 was switching to "fair" as the DRM scheduler default in place of the existing FIFO policy. The intent was on making the DRM scheduler policy more fair with this being used by AMDGPU and various other DRM kernel graphics drivers. But due to a last minute regression report, the fair policy is being reverted for Linux 7.2...