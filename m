From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-use-sysfses-release-mechanism-for-kmem_cache-fix.patch removed from
 -mm tree
Date: Mon, 05 May 2014 13:48:46 -0700
Message-ID: <5367f92e.B7jPfwBbQ3zUIoYF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaEEUsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tglx@linutronix.de, sasha.levin@oracle.com, rmk@arm.linux.org.uk, penberg@kernel.org, greg@kroah.com, cl@linux.com, bvanassche@acm.org, akpm@linux-foundation.org

Subject: [folded-merged] slub-use-sysfses-release-mechanism-for-kmem_cache-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bvanassche@acm.org,cl@linux.com,greg@kroah.com,penberg@kernel.org,rmk@arm.linux.org.uk,sasha.levin@oracle.com,tglx@linutronix.de,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:48:46 -0700


The patch titled
     Subject: slub-use-sysfses-release-mechanism-for-kmem_cache-fix
has been removed from the -mm tree.  Its filename was
     slub-use-sysfses-release-mechanism-for-kmem_cache-fix.patch

This patch was dropped because it was folded into slub-use-sysfses-release-mechanism-for-kmem_cache.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-use-sysfses-release-mechanism-for-kmem_cache-fix

fix CONFIG_SYSFS=n build

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~slub-use-sysfses-release-mechanism-for-kmem_cache-fix mm/slab_common.c
--- a/mm/slab_common.c~slub-use-sysfses-release-mechanism-for-kmem_cache-fix
+++ a/mm/slab_common.c
@@ -361,7 +361,7 @@ void kmem_cache_destroy(struct kmem_cach
 #ifdef SLAB_SUPPORTS_SYSFS
 	sysfs_slab_remove(s);
 #else
-	slab_kmem_cache_release();
+	slab_kmem_cache_release(s);
 #endif
 	goto out_put_cpus;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
slub-use-sysfses-release-mechanism-for-kmem_cache.patch
slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

