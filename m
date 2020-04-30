From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
 removed from -mm tree
Date: Wed, 29 Apr 2020 18:07:21 -0700
Message-ID: <20200430010721.X-X4_e6wC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgD3BHW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, lkp@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix

remove stray semicolon, half-written function

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
+++ a/include/linux/memcontrol.h
@@ -847,13 +847,8 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
-{
-
