From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
 removed from -mm tree
Date: Mon, 30 Sep 2013 13:41:27 -0700
Message-ID: <5249e1f7.Lp1cPC+BWrcNV+BY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3I3Ul2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 16:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aquini@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aquini@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 13:41:27 -0700


The patch titled
     Subject: mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix
has been removed from the -mm tree.  Its filename was
     mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch

This patch was dropped because it was folded into mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix

clarify awkward comment text

Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix
+++ a/include/linux/balloon_compaction.h
@@ -163,8 +163,8 @@ static inline bool balloon_page_movable(
  *			   compaction/migration page lists.
  *
  * After a compaction thread isolates a balloon page for migration, it raises
- * the page refcount to avoid concurrent compaction threads on re-isolating the
- * same page. For that reason putback_movable_pages(), or other routines
+ * the page refcount to prevent concurrent compaction threads from re-isolating
+ * the same page. For that reason putback_movable_pages(), or other routines
  * that need to identify isolated balloon pages on private pagelists, cannot
  * rely on balloon_page_movable() to accomplish the task.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
memblock-factor-out-of-top-down-allocation-hack.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

