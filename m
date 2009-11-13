From: akpm@linux-foundation.org
Subject: + lxfb-add-copyright-license-info.patch added to -mm tree
Date: Fri, 13 Nov 2009 12:03:37 -0800
Message-ID: <200911132003.nADK3bu1019118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271AbZKMUDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 15:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, jordan@cosmicpenguin.net


The patch titled
     lxfb: add copyright/license info
has been added to the -mm tree.  Its filename is
     lxfb-add-copyright-license-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: add copyright/license info
From: Andres Salomon <dilinger@collabora.co.uk>

The GRUB folks requested copyright/license info for lxfb.h, so here it is.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/video/geode/lxfb.h~lxfb-add-copyright-license-info drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-add-copyright-license-info
+++ a/drivers/video/geode/lxfb.h
@@ -1,3 +1,13 @@
+/* Geode LX framebuffer driver
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices,Inc.
+ * Copyright (c) 2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
 #ifndef _LXFB_H_
 #define _LXFB_H_
 
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch
lxfb-add-copyright-license-info.patch

