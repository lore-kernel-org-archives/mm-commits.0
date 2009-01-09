From: akpm@linux-foundation.org
Subject: - clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:18:21 -0800
Message-ID: <200901092018.n09KIMBs015992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbZAIUT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, damm@igel.co.jp, hugh@veritas.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource-pass-clocksource-to-read-callback-sparc-cleanup
has been removed from the -mm tree.  Its filename was
     clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch

This patch was dropped because it was folded into clocksource-pass-clocksource-to-read-callback.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource-pass-clocksource-to-read-callback-sparc-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

why'd we do that?

Cc: Hugh Dickins <hugh@veritas.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/timer_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback-sparc-cleanup arch/sparc/include/asm/timer_64.h
--- a/arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback-sparc-cleanup
+++ a/arch/sparc/include/asm/timer_64.h
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 
 struct sparc64_tick_ops {
-	unsigned long long (*get_tick)();
+	unsigned long long (*get_tick)(void);
 	int (*add_compare)(unsigned long);
 	unsigned long softint_mask;
 	void (*disable_irq)(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
kernel-trace-ring_bufferc-use-div_round_up-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

