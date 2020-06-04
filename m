From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 062/127] mm, memcg: fix some typos in memcontrol.c
Date: Thu, 04 Jun 2020 16:49:28 -0700
Message-ID: <20200604234928.61CcSpnmx%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:29 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
