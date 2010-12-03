From: akpm@linux-foundation.org
Subject: [obsolete] x86-olpc-add-xo-1-suspend-resume-support-fix.patch removed from -mm tree
Date: Thu, 02 Dec 2010 18:25:30 -0800
Message-ID: <201012030226.oB32QQ2L022211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189Ab0LCC03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2010 21:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dsd@laptop.org, mm-commits@vger.kernel.org


The patch titled
     x86-olpc-add-xo-1-suspend-resume-support-fix
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-xo-1-suspend-resume-support-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-olpc-add-xo-1-suspend-resume-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

make[3]: *** No rule to make target `arch/x86/platform/olpc/olpc-xo1-wakeup.c', needed by `arch/x86/platform/olpc/olpc-xo1-wakeup.o'.  Stop.

Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support-fix arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-1-suspend-resume-support-fix
+++ a/arch/x86/Kconfig
@@ -2064,6 +2064,7 @@ config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
 	select OLPC_OPENFIRMWARE
+	depends on X86_64
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

documentation-filesystems-vfstxt-fix-repeasepage-description.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source.patch
do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
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

