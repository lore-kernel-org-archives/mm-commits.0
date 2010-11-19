From: akpm@linux-foundation.org
Subject: [merged] lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch removed from -mm tree
Date: Fri, 19 Nov 2010 11:34:48 -0800
Message-ID: <201011191938.oAJJcPi1030700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0KSTjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 14:39:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, br1@einfach.org, kosaki.motohiro@jp.fujitsu.com, linville@tuxdriver.com, randy.dunlap@oracle.com, stefanr@s5r6.in-berlin.de, mm-comm


The patch titled
     lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
has been removed from the -mm tree.  Its filename was
     lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
From: Andrew Morton <akpm@linux-foundation.org>

include bug.h, per Stefan.

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/average.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/average.c~lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix lib/average.c
--- a/lib/average.c~lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
+++ a/lib/average.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/average.h>
+#include <linux/bug.h>
 
 /**
  * DOC: Exponentially Weighted Moving Average (EWMA)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

