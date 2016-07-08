From: akpm@linux-foundation.org
Subject: +
 mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch added
 to -mm tree
Date: Fri, 08 Jul 2016 14:17:47 -0700
Message-ID: <5780187b.9oZID1wWdoBUkSda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbcGHVRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch

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
Subject: mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#9: 
            bash-3863  [001] ....   141.791366: zs_compact_start: pool zram0

WARNING: line over 80 characters
#104: FILE: include/trace/events/zsmalloc.h:51:
+	TP_PROTO(int class, unsigned long nr_migrated_obj, unsigned long nr_freed_pages),

WARNING: Block comments use a trailing */ on a separate line
#137: FILE: mm/zsmalloc.c:1774:
+	 * in the subpage. */

total: 0 errors, 3 warnings, 134 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-zsmalloc-add-per-class-compact-trace-event.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes
+++ a/mm/zsmalloc.c
@@ -1770,8 +1770,10 @@ struct zs_compact_control {
 	/* Destination page for migration which should be a first page
 	 * of zspage. */
 	struct page *d_page;
-	/* Starting object index within @s_page which used for live object
-	 * in the subpage. */
+	/*
+	 * Starting object index within @s_page which used for live object in
+	 * the subpage.
+	 */
 	int obj_idx;
 
 	unsigned long nr_migrated_obj;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

