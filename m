From: akpm@linux-foundation.org
Subject: - full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:48:51 -0700
Message-ID: <200807252348.m6PNmpKb005857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYGYXti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eduard.munteanu@linux360.ro, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     full-conversion-to-early_initcall-interface-remove-old-interface-cleanup
has been removed from the -mm tree.  Its filename was
     full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch

This patch was dropped because it was folded into full-conversion-to-early_initcall-interface-remove-old-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: full-conversion-to-early_initcall-interface-remove-old-interface-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Somewhat more kernely coding style.

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c      |    1 -
 kernel/softirq.c    |    1 -
 kernel/softlockup.c |    2 --
 3 files changed, 4 deletions(-)

diff -puN kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup kernel/sched.c
--- a/kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup
+++ a/kernel/sched.c
@@ -6397,7 +6397,6 @@ static int __init migration_init(void)
 
 	return err;
 }
-
 early_initcall(migration_init);
 #endif
 
diff -puN kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup kernel/softirq.c
--- a/kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup
+++ a/kernel/softirq.c
@@ -651,7 +651,6 @@ static __init int spawn_ksoftirqd(void)
 	register_cpu_notifier(&cpu_nfb);
 	return 0;
 }
-
 early_initcall(spawn_ksoftirqd);
 
 #ifdef CONFIG_SMP
diff -puN kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup kernel/softlockup.c
--- a/kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface-cleanup
+++ a/kernel/softlockup.c
@@ -367,6 +367,4 @@ static int __init spawn_softlockup_task(
 
 	return 0;
 }
-
 early_initcall(spawn_softlockup_task);
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

