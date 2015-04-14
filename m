From: akpm@linux-foundation.org
Subject: [folded-merged]
 page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:15:12 -0700
Message-ID: <552d9170.7lYeVZH18nQ4EpDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, khlebnikov@yandex-team.ru, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch

This patch was dropped because it was folded into page_writeback-cleanup-mess-around-cancel_dirty_page.patch

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
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

