From: akpm@linux-foundation.org
Subject: [folded] sparc32-convert-to-asm-generic-hardirqh-fix.patch removed from -mm tree
Date: Mon, 28 Sep 2009 15:54:16 -0700
Message-ID: <200909282254.n8SMsGTD013303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbZI1Wya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Sep 2009 18:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hch@lst.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sparc32-convert-to-asm-generic-hardirqh-fix
has been removed from the -mm tree.  Its filename was
     sparc32-convert-to-asm-generic-hardirqh-fix.patch

This patch was dropped because it was folded into sparc32-convert-to-asm-generic-hardirqh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc32-convert-to-asm-generic-hardirqh-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/asm-generic/hardirq.h:6,
                 from /usr/src/devel/arch/sparc/include/asm/hardirq_32.h:11,
                 from /usr/src/devel/arch/sparc/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:10,
                 from include/linux/interrupt.h:12,
                 from /usr/src/devel/arch/sparc/include/asm/irq_32.h:9,
                 from /usr/src/devel/arch/sparc/include/asm/irq.h:6,
                 from include/linux/nmi.h:8,
                 from kernel/sched.c:31:
include/linux/irq.h:216: error: 'NR_IRQS' undeclared here (not in a function)

Cc: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/irq_32.h |    4 ++--
 sparc/include/asm/irq_64.h      |    0 
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh-fix arch/sparc/include/asm/irq_32.h
--- a/arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh-fix
+++ a/arch/sparc/include/asm/irq_32.h
@@ -6,10 +6,10 @@
 #ifndef _SPARC_IRQ_H
 #define _SPARC_IRQ_H
 
-#include <linux/interrupt.h>
-
 #define NR_IRQS    16
 
+#include <linux/interrupt.h>
+
 #define irq_canonicalize(irq)	(irq)
 
 extern void __init init_IRQ(void);
diff -puN arch/sparc/include/asm/irq_64.h~sparc32-convert-to-asm-generic-hardirqh-fix arch/sparc/include/asm/irq_64.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-input-inputc-fix-config_pm=n-warning.patch
sparc32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

