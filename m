From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch removed from -mm tree
Date: Mon, 10 Jul 2017 15:33:24 -0700
Message-ID: <596400b4.hdorl5Hs5v2uPqye%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdGJWda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, js1304@gmail.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch

This patch was dropped because it was folded into hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix

remove bogus arg from alloc_huge_page_nodemask() stub

Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix
+++ a/include/linux/hugetlb.h
@@ -525,7 +525,7 @@ static inline void set_huge_swap_pte_at(
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
-#define alloc_huge_page_nodemask(h, preferred_nid, nmask) NULL
+#define alloc_huge_page_nodemask(h, nmask) NULL
 #define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

