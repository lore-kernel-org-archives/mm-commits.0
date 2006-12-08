From: akpm@osdl.org
Subject: - gxfb-fixups-for-the-amd-geode-gx-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:08:41 -0800
Message-ID: <200612080908.kB898fMZ014474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425273AbWLHJI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, adaplas@pol.net, jordan.crouse@amd.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb-fixups-for-the-amd-geode-gx-tidy
has been removed from the -mm tree.  Its filename was
     gxfb-fixups-for-the-amd-geode-gx-tidy.patch

This patch was dropped because it was folded into gxfb-fixups-for-the-amd-geode-gx.patch

------------------------------------------------------
Subject: gxfb-fixups-for-the-amd-geode-gx-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/display_gx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/geode/display_gx.c~gxfb-fixups-for-the-amd-geode-gx-tidy drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-fixups-for-the-amd-geode-gx-tidy
+++ a/drivers/video/geode/display_gx.c
@@ -22,7 +22,8 @@
 #include "display_gx.h"
 
 #ifdef CONFIG_FB_GEODE_GX_SET_FBSIZE
-unsigned int gx_frame_buffer_size(void) {
+unsigned int gx_frame_buffer_size(void)
+{
 	return CONFIG_FB_GEODE_GX_FBSIZE;
 }
 #else
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

