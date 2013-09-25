From: akpm@linux-foundation.org
Subject: +
 mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch added
 to -mm tree
Date: Wed, 25 Sep 2013 15:42:35 -0700
Message-ID: <524366db.vPvLUSdTbJtwtQ9T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3IYWmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 18:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aquini@redhat.com, akpm@linux-foundation.org

Subject: + mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aquini@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 15:42:35 -0700


The patch titled
     Subject: mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix
has been added to the -mm tree.  Its filename is
     mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch

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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
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
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

