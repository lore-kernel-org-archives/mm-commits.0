From: akpm@linux-foundation.org
Subject: + slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch added to -mm tree
Date: Fri, 20 Jun 2014 14:10:23 -0700
Message-ID: <53a4a33f.xKOwG4yd5t6+EfjJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaFTVKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 17:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, cl@linux.com, akpm@linux-foundation.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix
has been added to the -mm tree.  Its filename is
     slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix

Cc: Christoph Lameter <cl@linux.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix
+++ a/mm/slab.c
@@ -590,7 +590,8 @@ static inline void on_slab_lock_classes_
 {
 }
 
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep,
+	struct kmem_cache_node *n)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

