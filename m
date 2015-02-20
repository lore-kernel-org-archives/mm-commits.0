From: akpm@linux-foundation.org
Subject: +
 page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch added to -mm tree
Date: Fri, 20 Feb 2015 13:36:50 -0800
Message-ID: <54e7a8f2.0zygUai6+3SgNo/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbbBTVgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, khlebnikov@yandex-team.ru, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch

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
Subject: page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes

WARNING: 'loosing' may be misspelled - perhaps 'losing'?
#145: FILE: mm/filemap.c:207:
+	 * Dirty page here signals about bug and loosing unwitten data.

total: 0 errors, 1 warnings, 155 lines checked

./patches/page_writeback-cleanup-mess-around-cancel_dirty_page.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes mm/filemap.c
--- a/mm/filemap.c~page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes
+++ a/mm/filemap.c
@@ -204,7 +204,7 @@ void __delete_from_page_cache(struct pag
 
 	/*
 	 * At this point page must be either written or cleaned by truncate.
-	 * Dirty page here signals about bug and loosing unwitten data.
+	 * Dirty page here signals a bug and loss of unwritten data.
 	 *
 	 * This fixes dirty accounting after removing the page entirely but
 	 * leaves PageDirty set: it has no effect for truncated page and
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

