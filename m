From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-obsolete-comment.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:51:19 -0700
Message-ID: <552fe887.WqvuuCbgx2DVX21o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbbDPQpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove obsolete comment
has been removed from the -mm tree.  Its filename was
     memcg-remove-obsolete-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove obsolete comment

Low and high watermarks, as they defined in the TODO to the mem_cgroup
struct, have already been implemented by Johannes, so remove the stale
comment.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-obsolete-comment mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-obsolete-comment
+++ a/mm/memcontrol.c
@@ -259,11 +259,6 @@ static void mem_cgroup_oom_notify(struct
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
  * to help the administrator determine what knobs to tune.
- *
- * TODO: Add a water mark for the memory controller. Reclaim will begin when
- * we hit the water mark. May be even add a low water mark, such that
- * no reclaim occurs from a cgroup at it's low water mark, this is
- * a feature that will be implemented much later in the future.
  */
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch
linux-next.patch

