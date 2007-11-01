From: akpm@linux-foundation.org
Subject: + make-video-geode-lxfb_corecgeode_modedb-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:30:26 -0700
Message-ID: <200711010730.lA17UQ6V018322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbXKAHap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, adaplas@gmail.com, jordan.crouse@amd.com


The patch titled
     make video/geode/lxfb_core.c:geode_modedb[] static
has been added to the -mm tree.  Its filename is
     make-video-geode-lxfb_corecgeode_modedb-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
