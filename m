From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 14:50:13 -0800
Message-ID: <5a7b82a5.WxesKMudNSOk+cxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGWuO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:50:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-remove-reason-argument-from-new_page_t-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch

This patch was dropped because it was folded into mm-migrate-remove-reason-argument-from-new_page_t.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-remove-reason-argument-from-new_page_t-fix-fix

fix alloc_misplaced_dst_page()

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-migrate-remove-reason-argument-from-new_page_t-fix-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-remove-reason-argument-from-new_page_t-fix-fix
+++ a/mm/migrate.c
@@ -1783,8 +1783,7 @@ static bool migrate_balanced_pgdat(struc
 }
 
 static struct page *alloc_misplaced_dst_page(struct page *page,
-					   unsigned long data,
-					   int **result)
+					   unsigned long data)
 {
 	int nid = (int) data;
 	struct page *newpage;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

