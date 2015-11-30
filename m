From: akpm@linux-foundation.org
Subject: + mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
 added to -mm tree
Date: Mon, 30 Nov 2015 15:17:57 -0800
Message-ID: <565cd925.PrJz1HnsuwDnIZsu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbbK3XR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 18:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: dump page owner info from dump_page()-fix
has been added to the -mm tree.  Its filename is
     mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: dump page owner info from dump_page()-fix

Remove stray semicolon.

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page-fix
+++ a/mm/page_owner.c
@@ -207,7 +207,7 @@ void __dump_page_owner(struct page *page
 		pr_alert("page_owner info is not active (free page?)\n");
 		return;
 	}
-			                        ;
+
 	pr_alert("page allocated via order %u, migratetype %s, gfp_mask 0x%x",
 			page_ext->order, migratetype_names[mt], gfp_mask);
 	dump_gfpflag_names(gfp_mask);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

