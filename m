From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-some-typos-in-memcontrolc.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 15:51:52 -0700
Message-ID: <20200413225152.cUZiWXaxA%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389783AbgDMWur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:50:47 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix some typos in memcontrol.c
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-some-typos-in-memcontrolc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-some-typos-in-memcontrolc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-some-typos-in-memcontrolc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3203,7 +3203,7 @@ unsigned long mem_cgroup_soft_limit_recl
  * Test whether @memcg has children, dead or alive.  Note that this
  * function doesn't care whether @memcg has use_hierarchy enabled and
  * returns %true if there are child csses according to the cgroup
- * hierarchy.  Testing use_hierarchy is the caller's responsiblity.
+ * hierarchy.  Testing use_hierarchy is the caller's responsibility.
  */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
@@ -4853,7 +4853,7 @@ static struct cftype mem_cgroup_legacy_f
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

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-vmsan-fix-some-typos-in-comment.patch
mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
mm-memblock-fix-a-typo-in-comment-implict-implicit.patch
mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch
mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch
mm-frontswap-fix-some-typos-in-frontswapc.patch
mm-memcg-fix-some-typos-in-memcontrolc.patch
mm-fix-a-typo-in-comment-strucure-structure.patch
