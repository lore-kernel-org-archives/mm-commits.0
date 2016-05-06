From: akpm@linux-foundation.org
Subject: + memcg-fix-stale-mem_cgroup_force_empty-comment.patch added to
 -mm tree
Date: Fri, 06 May 2016 15:13:08 -0700
Message-ID: <572d16f4.VY93jCF2eJn+zdNJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbcEFWNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix stale mem_cgroup_force_empty() comment
has been added to the -mm tree.  Its filename is
     memcg-fix-stale-mem_cgroup_force_empty-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-stale-mem_cgroup_force_empty-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-stale-mem_cgroup_force_empty-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: fix stale mem_cgroup_force_empty() comment

commit f61c42a7d911 ("memcg: remove tasks/children test from
mem_cgroup_force_empty()") removed memory reparenting from the function.

Fix the function's comment.

Link: http://lkml.kernel.org/r/1462569810-54496-1-git-send-email-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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

memcg-fix-stale-mem_cgroup_force_empty-comment.patch

