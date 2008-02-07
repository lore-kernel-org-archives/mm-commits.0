From: akpm@linux-foundation.org
Subject: - make-video-geode-lxfb_corecgeode_modedb-static.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:05 -0800
Message-ID: <200802070027.m170Rkb1007081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762736AbYBGApd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, adaplas@gmail.com, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     make video/geode/lxfb_core.c:geode_modedb[] static
has been removed from the -mm tree.  Its filename was
     make-video-geode-lxfb_corecgeode_modedb-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make video/geode/lxfb_core.c:geode_modedb[] static
From: Adrian Bunk <bunk@kernel.org>

geode_modedb[] can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/geode/lxfb_core.c~make-video-geode-lxfb_corecgeode_modedb-static drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~make-video-geode-lxfb_corecgeode_modedb-static
+++ a/drivers/video/geode/lxfb_core.c
@@ -34,7 +34,7 @@ static int fbsize;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-const struct fb_videomode geode_modedb[] __initdata = {
+static const struct fb_videomode geode_modedb[] __initdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
