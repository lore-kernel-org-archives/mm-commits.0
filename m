From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-stale-mem_cgroup_force_empty-comment.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:46:36 -0700
Message-ID: <57435e1c.k5ezUvdLKKV/e/hW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix stale mem_cgroup_force_empty() comment
has been removed from the -mm tree.  Its filename was
     memcg-fix-stale-mem_cgroup_force_empty-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: fix stale mem_cgroup_force_empty() comment

commit f61c42a7d911 ("memcg: remove tasks/children test from
mem_cgroup_force_empty()") removed memory reparenting from the function.

Fix the function's comment.

Link: http://lkml.kernel.org/r/1462569810-54496-1-git-send-email-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-stale-mem_cgroup_force_empty-comment mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-stale-mem_cgroup_force_empty-comment
+++ a/mm/memcontrol.c
@@ -2652,8 +2652,7 @@ static inline bool memcg_has_children(st
 }
 
 /*
- * Reclaims as many pages from the given memcg as possible and moves
- * the rest to the parent.
+ * Reclaims as many pages from the given memcg as possible.
  *
  * Caller is responsible for holding css reference for memcg.
  */
_

Patches currently in -mm which might be from gthelen@google.com are


