From: akpm@linux-foundation.org
Subject: - rtc-remove-sys-class-rtc-dev-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 22:18:18 -0700
Message-ID: <200705080518.l485IIHB014265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967873AbXEHFSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-dev.c should #include "rtc-core.h"
has been removed from the -mm tree.  Its filename was
     rtc-remove-sys-class-rtc-dev-fix.patch

This patch was dropped because it was folded into rtc-remove-sys-class-rtc-dev.patch

------------------------------------------------------
Subject: drivers/rtc/rtc-dev.c should #include "rtc-core.h"
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-dev.c~rtc-remove-sys-class-rtc-dev-fix drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-sys-class-rtc-dev-fix
+++ a/drivers/rtc/rtc-dev.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include "rtc-core.h"
 
 static dev_t rtc_devt;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
