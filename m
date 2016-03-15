From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch removed
 from -mm tree
Date: Tue, 15 Mar 2016 14:40:37 -0700
Message-ID: <56e88155.Ca/kYZF6iZ6+ljwJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcCOVki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch

This patch was dropped because it was folded into mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix

hrm

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix
+++ a/mm/migrate.c
@@ -1845,7 +1845,7 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	mem_cgroup_migrate(page, newpage);
+	mem_cgroup_migrate(page, new_page);
 	page_remove_rmap(page, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

