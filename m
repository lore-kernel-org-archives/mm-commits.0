From: akpm@linux-foundation.org
Subject: + remove-__gfp_no_kswapd-fixes-fix.patch added to -mm tree
Date: Wed, 25 Jul 2012 16:38:56 -0700
Message-ID: <20120725233857.68D675C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53779 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2GYXi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 19:38:59 -0400
Received: by fat25 with SMTP id 25so58625fat.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 16:38:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: remove-__gfp_no_kswapd-fixes-fix
has been added to the -mm tree.  Its filename is
     remove-__gfp_no_kswapd-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: remove-__gfp_no_kswapd-fixes-fix

Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes-fix drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes-fix
+++ a/drivers/mtd/mtdcore.c
@@ -1065,8 +1065,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying, swapping, writing back
- * or performing I/O.
+ * ask the memory allocator to avoid re-trying.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-have-order-0-compaction-start-off-where-it-left-v3.patch
vmscan-remove-obsolete-shrink_control-comment.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
mips-zero-out-pg_data_t-when-its-allocated.patch
mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch
mm-remove-redundant-initialization.patch
remove-__gfp_no_kswapd-fixes-fix.patch

