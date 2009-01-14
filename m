From: akpm@linux-foundation.org
Subject: [failures] rtc-cumulative-style-fixes-fix.patch removed from -mm tree
Date: Wed, 14 Jan 2009 15:24:36 -0800
Message-ID: <200901142341.n0ENf8aH001136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbZANXnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 18:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, andrew@sanpeople.com, ben@simtec.co.uk, dbrownell@users.sourceforge.net, dsaxena@plexity.net, gl@dsa-ac.de, iwamatsu@nigauri.org, kyle


The patch titled
     rtc-cumulative-style-fixes-fix
has been removed from the -mm tree.  Its filename was
     rtc-cumulative-style-fixes-fix.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cumulative-style-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: G. Liakhovetski <gl@dsa-ac.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Pavel Mironchik <pmironchik@optifacio.net>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    2 ++
 drivers/rtc/rtc-parisc.c |    2 ++
 drivers/rtc/rtc-sh.c     |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-ds1302.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/bcd.h>
 
+#include <asm/rtc.h>
+
 #define DRV_NAME	"rtc-ds1302"
 #define DRV_VERSION	"0.1.0"
 
diff -puN drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-parisc.c
@@ -9,6 +9,8 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 
+#include <asm/rtc.h>
+
 /* as simple as can be, and no simpler. */
 struct parisc_rtc {
 	struct rtc_device *rtc;
diff -puN drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes-fix drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes-fix
+++ a/drivers/rtc/rtc-sh.c
@@ -26,6 +26,8 @@
 #include <linux/io.h>
 #include <linux/log2.h>
 
+#include <asm/rtc.h>
+
 #define DRV_NAME	"sh-rtc"
 #define DRV_VERSION	"0.2.0"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch
alpha-fix-vmalloc-breakage-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

