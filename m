From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-fix-thresholds-for-32b-architectures-fix.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:29:56 -0800
Message-ID: <563c10a4.bXZqbsyIdN/l1Pyk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, ben@decadent.org.uk, hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-thresholds-for-32b-architectures-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-thresholds-for-32b-architectures-fix.patch

This patch was dropped because it was folded into memcg-fix-thresholds-for-32b-architectures.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: memcg-fix-thresholds-for-32b-architectures-fix

Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix
+++ a/mm/memcontrol.c
@@ -2803,7 +2803,7 @@ static unsigned long tree_stat(struct me
 
 static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
-	u64 val;
+	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
 		val = tree_stat(memcg, MEM_CGROUP_STAT_CACHE);
_

Patches currently in -mm which might be from mhocko@kernel.org are

memcg-fix-thresholds-for-32b-architectures.patch

