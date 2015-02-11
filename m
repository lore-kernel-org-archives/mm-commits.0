From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:15:55 -0800
Message-ID: <54dbe2ab.iYZuhMLUw7c78Ume%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbbBKXP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch

This patch was dropped because it was folded into mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix

fix sparse warning

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix
+++ a/mm/compaction.c
@@ -35,7 +35,7 @@ static inline void count_compact_events(
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 #ifdef CONFIG_TRACEPOINTS
-static const char const *compaction_status_string[] = {
+static const char *const compaction_status_string[] = {
 	"deferred",
 	"skipped",
 	"continue",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

