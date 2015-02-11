From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fold-move_anon-and-move_file-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:14:17 -0800
Message-ID: <54dbe249.oJ68mEcNUpSMb7At%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbBKXOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fold-move_anon-and-move_file-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fold-move_anon-and-move_file-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fold-move_anon-and-move_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-fold-move_anon-and-move_file-fix

tweak MOVE_MASK definition, per Michal

Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file-fix
+++ a/mm/memcontrol.c
@@ -373,7 +373,7 @@ bool memcg_kmem_is_active(struct mem_cgr
  */
 #define MOVE_ANON	0x1U
 #define MOVE_FILE	0x2U
-#define MOVE_MASK	0x3U
+#define MOVE_MASK	(MOVE_ANON | MOVE_FILE)
 
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

