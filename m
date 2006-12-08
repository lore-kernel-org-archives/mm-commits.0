From: akpm@osdl.org
Subject: - fault-injection-capabilities-infrastructure-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:58:55 -0800
Message-ID: <200612080858.kB88wtK5014211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38073 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425262AbWLHI7I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, akinobu.mita@gmail.com, dwm@meer.net, okuji@enbug.org, mm-commits@vger.kernel.org


The patch titled
     fault-injection-capabilities-infrastructure-tidy
has been removed from the -mm tree.  Its filename was
     fault-injection-capabilities-infrastructure-tidy.patch

This patch was dropped because it was folded into fault-injection-capabilities-infrastructure.patch

------------------------------------------------------
Subject: fault-injection-capabilities-infrastructure-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: <okuji@enbug.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Kconfig.debug |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~fault-injection-capabilities-infrastructure-tidy lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-capabilities-infrastructure-tidy
+++ a/lib/Kconfig.debug
@@ -423,6 +423,6 @@ config FAULT_INJECTION_DEBUG_FS
 	depends on FAULT_INJECTION && SYSFS
 	select DEBUG_FS
 	help
-	  This option enables to configure fault-injection capabilities via
-	  debugfs entries.
+	  This option enable configuration of fault-injection capabilities via
+	  debugfs.
 
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
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

