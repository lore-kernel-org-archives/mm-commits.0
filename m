From: akpm@linux-foundation.org
Subject: [folded-merged] mm-simplify-lock_page_memcg-fix.patch removed
 from -mm tree
Date: Tue, 15 Mar 2016 14:42:13 -0700
Message-ID: <56e881b5.R/cB9wpqXZN8iiDB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcCOVmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-lock_page_memcg-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-lock_page_memcg-fix.patch

This patch was dropped because it was folded into mm-simplify-lock_page_memcg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-lock_page_memcg-fix

In file included from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/memcontrol.h: In function 'lock_page_memcg':
include/linux/memcontrol.h:666: warning: 'return' with a value, in function returning void
In file included from include/linux/swap.h:8,
                 from mm/mlock.c:11:
include/linux/memcontrol.h: In function 'lock_page_memcg':
include/linux/memcontrol.h:666: warning: 'return' with a value, in function returning void

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-simplify-lock_page_memcg-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-simplify-lock_page_memcg-fix
+++ a/include/linux/memcontrol.h
@@ -663,7 +663,6 @@ mem_cgroup_print_oom_info(struct mem_cgr
 
 static inline void lock_page_memcg(struct page *page)
 {
-	return NULL;
 }
 
 static inline void unlock_page_memcg(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-simplify-lock_page_memcg.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

