From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-fix-some-typos-in-memcontrolc.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:36 -0700
Message-ID: <20200605201836.tFR1NsBtw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix some typos in memcontrol.c
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-some-typos-in-memcontrolc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm, memcg: fix some typos in memcontrol.c

There are some typos in comment, fix them.

s/responsiblity/responsibility
s/oflline/offline

Link: http://lkml.kernel.org/r/20200411064246.15781-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-some-typos-in-memcontrolc
+++ a/mm/memcontrol.c
@@ -3186,7 +3186,7 @@ unsigned long mem_cgroup_soft_limit_recl
  * Test whether @memcg has children, dead or alive.  Note that this
  * function doesn't care whether @memcg has use_hierarchy enabled and
  * returns %true if there are child csses according to the cgroup
- * hierarchy.  Testing use_hierarchy is the caller's responsiblity.
+ * hierarchy.  Testing use_hierarchy is the caller's responsibility.
  */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
@@ -4838,7 +4838,7 @@ static struct cftype mem_cgroup_legacy_f
  * limited to 16 bit (MEM_CGROUP_ID_MAX), limiting the total number of
  * memory-controlled cgroups to 64k.
  *
- * However, there usually are many references to the oflline CSS after
+ * However, there usually are many references to the offline CSS after
  * the cgroup has been destroyed, such as page cache or reclaimable
  * slab objects, that don't need to hang on to the ID. We want to keep
  * those dead CSS from occupying IDs, or we might quickly exhaust the
_

Patches currently in -mm which might be from ethp@qq.com are
