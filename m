From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch removed
 from -mm tree
Date: Fri, 20 May 2016 16:33:06 -0700
Message-ID: <573f9eb2.PKtHtModBjNlNOGP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbcETXdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-abstract-compaction-feedback-to-helpers-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch

This patch was dropped because it was folded into mm-compaction-abstract-compaction-feedback-to-helpers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-abstract-compaction-feedback-to-helpers-fix

fix typo in comment, per Hillf

Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers-fix
+++ a/include/linux/compaction.h
@@ -95,7 +95,7 @@ static inline bool compaction_made_progr
 /* Compaction has failed and it doesn't make much sense to keep retrying. */
 static inline bool compaction_failed(enum compact_result result)
 {
-	/* All zones where scanned completely and still not result. */
+	/* All zones were scanned completely and still not result. */
 	if (result == COMPACT_COMPLETE)
 		return true;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

