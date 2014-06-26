From: akpm@linux-foundation.org
Subject: +
 kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 26 Jun 2014 14:09:42 -0700
Message-ID: <53ac8c16.E0GX/gVZn01nJpvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFZVJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch

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
Subject: kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes

WARNING: else is not generally useful after a break or return
#673: FILE: kernel/kexec.c:2024:
+		return locate_mem_hole_top_down(start, end, kbuf);
+	else

total: 0 errors, 1 warnings, 677 lines checked

./patches/kexec-implementation-of-new-syscall-kexec_file_load.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes kernel/kexec.c
--- a/kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes
+++ a/kernel/kexec.c
@@ -2021,8 +2021,7 @@ static int locate_mem_hole_callback(u64
 	 */
 	if (kbuf->top_down)
 		return locate_mem_hole_top_down(start, end, kbuf);
-	else
-		return locate_mem_hole_bottom_up(start, end, kbuf);
+	return locate_mem_hole_bottom_up(start, end, kbuf);
 }
 
 /*
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
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

