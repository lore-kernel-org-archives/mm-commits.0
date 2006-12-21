From: akpm@osdl.org
Subject: - drm-stop-defining-pci_pretty_name.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:47 -0800
Message-ID: <200612210036.kBL0alZX011226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161103AbWLUAhM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     DRM: Stop defining pci_pretty_name
has been removed from the -mm tree.  Its filename was
     drm-stop-defining-pci_pretty_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DRM: Stop defining pci_pretty_name
From: Jean Delvare <khali@linux-fr.org>

DRM drivers no longer use pci_pretty_name so we can stop defining it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/drmP.h |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/char/drm/drmP.h~drm-stop-defining-pci_pretty_name drivers/char/drm/drmP.h
--- a/drivers/char/drm/drmP.h~drm-stop-defining-pci_pretty_name
+++ a/drivers/char/drm/drmP.h
@@ -1143,9 +1143,5 @@ extern void *drm_calloc(size_t nmemb, si
 extern unsigned long drm_core_get_map_ofs(drm_map_t * map);
 extern unsigned long drm_core_get_reg_ofs(struct drm_device *dev);
 
-#ifndef pci_pretty_name
-#define pci_pretty_name(dev) ""
-#endif
-
 #endif				/* __KERNEL__ */
 #endif
_

Patches currently in -mm which might be from khali@linux-fr.org are

git-alsa.patch
git-drm.patch

