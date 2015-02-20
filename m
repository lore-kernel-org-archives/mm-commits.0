From: akpm@linux-foundation.org
Subject: + mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch added to
 -mm tree
Date: Fri, 20 Feb 2015 13:46:09 -0800
Message-ID: <54e7ab21.py6PwOgip0cpUCJZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbbBTVqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hide-per-cpu-lists-in-output-of-show_mem-fix
has been added to the -mm tree.  Its filename is
     mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch

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
Subject: mm-hide-per-cpu-lists-in-output-of-show_mem-fix

update show_free_areas comment

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem-fix
+++ a/mm/page_alloc.c
@@ -3243,8 +3243,11 @@ static void show_migration_types(unsigne
  * Show free area list (used inside shift_scroll-lock stuff)
  * We also calculate the percentage fragmentation. We do this by counting the
  * memory on each free list with the exception of the first item on the list.
- * Suppresses nodes that are not allowed by current's cpuset if
- * SHOW_MEM_FILTER_NODES is passed.
+ *
+ * Bits in @filter:
+ * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
+ *   cpuset.
+ * SHOW_MEM_PERCPU_LISTS: display full per-node per-cpu pcp lists
  */
 void show_free_areas(unsigned int filter)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

