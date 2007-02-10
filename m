From: akpm@linux-foundation.org
Subject: - drm-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:20:06 -0800
Message-ID: <200702100520.l1A5K6Bb004438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbXBJFU1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     drm-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drm: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_proc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/drm_proc.c~drm-use-array_size-macro-when-appropriate drivers/char/drm/drm_proc.c
--- a/drivers/char/drm/drm_proc.c~drm-use-array_size-macro-when-appropriate
+++ a/drivers/char/drm/drm_proc.c
@@ -72,7 +72,7 @@ static struct drm_proc_list {
 #endif
 };
 
-#define DRM_PROC_ENTRIES (sizeof(drm_proc_list)/sizeof(drm_proc_list[0]))
+#define DRM_PROC_ENTRIES ARRAY_SIZE(drm_proc_list)
 
 /**
  * Initialize the DRI proc filesystem for a device.
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
arch-arm-use-array_size-macro-when-appropriate.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
git-scsi-misc.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
