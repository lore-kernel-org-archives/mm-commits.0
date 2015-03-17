From: akpm@linux-foundation.org
Subject: + memcg-remove-obsolete-comment.patch added to -mm tree
Date: Tue, 17 Mar 2015 16:27:18 -0700
Message-ID: <5508b856.FbbFUIomsFry+kS6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbbCQX1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 19:27:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove obsolete comment
has been added to the -mm tree.  Its filename is
     memcg-remove-obsolete-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-obsolete-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-obsolete-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
memcg-zap-mem_cgroup_lookup.patch
memcg-remove-obsolete-comment.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch

