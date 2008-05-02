From: akpm@linux-foundation.org
Subject: - arch-x86-video-fbdevc-add-module_license.patch removed from -mm tree
Date: Fri, 02 May 2008 15:20:14 -0700
Message-ID: <200805022220.m42MKEbU017826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936351AbYEBWUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/video/fbdev.c: add MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     arch-x86-video-fbdevc-add-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/video/fbdev.c: add MODULE_LICENSE
From: Adrian Bunk <bunk@kernel.org>

Add the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/video/fbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/video/fbdev.c~arch-x86-video-fbdevc-add-module_license arch/x86/video/fbdev.c
--- a/arch/x86/video/fbdev.c~arch-x86-video-fbdevc-add-module_license
+++ a/arch/x86/video/fbdev.c
@@ -1,5 +1,4 @@
 /*
- *
  * Copyright (C) 2007 Antonino Daplas <adaplas@gmail.com>
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -29,3 +28,4 @@ int fb_is_primary_device(struct fb_info 
 	return retval;
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch

