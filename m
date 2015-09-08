From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-export-struct-mem_cgroup-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:41:46 -0700
Message-ID: <55ef561a.kO9+oxQhqvkOU+2q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbIHVlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-export-struct-mem_cgroup-fix
has been removed from the -mm tree.  Its filename was
     memcg-export-struct-mem_cgroup-fix.patch

This patch was dropped because it was folded into memcg-export-struct-mem_cgroup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-export-struct-mem_cgroup-fix

memcontrol.h needs eventfd.h for eventfd_ctx.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/memcontrol.h~memcg-export-struct-mem_cgroup-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-export-struct-mem_cgroup-fix
+++ a/include/linux/memcontrol.h
@@ -25,6 +25,7 @@
 #include <linux/jump_label.h>
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
+#include <linux/eventfd.h>
 #include <linux/mmzone.h>
 #include <linux/writeback.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

