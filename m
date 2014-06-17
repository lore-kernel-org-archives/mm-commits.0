From: akpm@linux-foundation.org
Subject: + slub-use-new-node-functions-checkpatch-fixes.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:19:48 -0700
Message-ID: <53a0b0f4.YQJ7jTI8VZH1k+gp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965420AbaFQVTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cl@linux.com, akpm@linux-foundation.org


The patch titled
     Subject: slub-use-new-node-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     slub-use-new-node-functions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-use-new-node-functions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-use-new-node-functions-checkpatch-fixes.patch

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
Subject: slub-use-new-node-functions-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#189: FILE: mm/slub.c:4350:
+	for(node = 0; node < nr_node_ids; node++)

total: 1 errors, 0 warnings, 192 lines checked

./patches/slub-use-new-node-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-use-new-node-functions-checkpatch-fixes mm/slub.c
--- a/mm/slub.c~slub-use-new-node-functions-checkpatch-fixes
+++ a/mm/slub.c
@@ -4347,7 +4347,7 @@ static ssize_t show_slab_objects(struct
 	}
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
-	for(node = 0; node < nr_node_ids; node++)
+	for (node = 0; node < nr_node_ids; node++)
 		if (nodes[node])
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
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
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
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

