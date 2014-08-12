From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-lookup_cgroup_page-prototype.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:06 -0700
Message-ID: <53ea6d1e.UIGfmns57j1R3unw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:65415 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:07 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1910723oig.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove lookup_cgroup_page() prototype
has been removed from the -mm tree.  Its filename was
     memcg-remove-lookup_cgroup_page-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: remove lookup_cgroup_page() prototype

6b208e3f6e35 ("mm: memcg: remove unused node/section info from pc->flags")
deleted lookup_cgroup_page() but left a prototype for it.

Kill the vestigial prototype.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-lookup_cgroup_page-prototype include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-lookup_cgroup_page-prototype
+++ a/include/linux/page_cgroup.h
@@ -40,7 +40,6 @@ static inline void page_cgroup_init(void
 #endif
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
-struct page *lookup_cgroup_page(struct page_cgroup *pc);
 
 static inline int PageCgroupUsed(struct page_cgroup *pc)
 {
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

