From: akpm@osdl.org
Subject: - gxfb-support-flat-panel-timings-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:09:00 -0800
Message-ID: <200612080909.kB8990PP014477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425279AbWLHJJL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, adaplas@pol.net, jordan.crouse@amd.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb-support-flat-panel-timings-tidy
has been removed from the -mm tree.  Its filename was
     gxfb-support-flat-panel-timings-tidy.patch

This patch was dropped because it was folded into gxfb-support-flat-panel-timings.patch

------------------------------------------------------
Subject: gxfb-support-flat-panel-timings-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/video_gx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/geode/video_gx.c~gxfb-support-flat-panel-timings-tidy drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-support-flat-panel-timings-tidy
+++ a/drivers/video/geode/video_gx.c
@@ -176,8 +176,8 @@ static void gx_set_dclk_frequency(struct
 }
 
 static void
-gx_configure_tft(struct fb_info *info) {
-
+gx_configure_tft(struct fb_info *info)
+{
 	struct geodefb_par *par = info->par;
 	unsigned long val;
 	unsigned long fp;
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
gxfb-support-flat-panel-timings.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

