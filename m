From: akpm@linux-foundation.org
Subject: + lib-list_sortc-convert-to-pr_foo-fix.patch added to -mm tree
Date: Wed, 25 Jun 2014 15:35:18 -0700
Message-ID: <53ab4ea6.PzeIZg84FdwEIm6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaFYWfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 18:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-list_sortc-convert-to-pr_foo-fix
has been added to the -mm tree.  Its filename is
     lib-list_sortc-convert-to-pr_foo-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sortc-convert-to-pr_foo-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sortc-convert-to-pr_foo-fix.patch

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
Subject: lib-list_sortc-convert-to-pr_foo-fix

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/list_sort.c~lib-list_sortc-convert-to-pr_foo-fix lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo-fix
+++ a/lib/list_sort.c
@@ -128,8 +128,7 @@ void list_sort(void *priv, struct list_h
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				pr_debug_once("list passed to list_sort() too "
-					      "long for efficiency\n");
+				printk_once(KERN_DEBUG "list too long for efficiency\n");
 				lev--;
 			}
 			max_lev = lev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
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
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
fs-isofs-logging-clean-up-fix.patch
panic-add-taint_softlockup-fix.patch
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

