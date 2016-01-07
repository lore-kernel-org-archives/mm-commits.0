From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch removed from
 -mm tree
Date: Thu, 07 Jan 2016 15:49:28 -0800
Message-ID: <568ef988.w53GELWE23BLy10X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcAGXta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: dump page owner info from dump_page()-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch

This patch was dropped because it was folded into mm-page_owner-dump-page-owner-info-from-dump_page.patch

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

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

