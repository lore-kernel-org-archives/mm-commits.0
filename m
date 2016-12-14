From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch removed from -mm tree
Date: Wed, 14 Dec 2016 14:28:04 -0800
Message-ID: <5851c774.GhRqlVe6sOPYp2SB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbcLNW1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fromorbit.com, js1304@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-allow-compaction-for-gfp_nofs-requests-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch

This patch was dropped because it was folded into mm-compaction-allow-compaction-for-gfp_nofs-requests.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-allow-compaction-for-gfp_nofs-requests-fix

fix comment

Cc: Dave Chinner <david@fromorbit.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-allow-compaction-for-gfp_nofs-requests-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-allow-compaction-for-gfp_nofs-requests-fix
+++ a/mm/compaction.c
@@ -1691,7 +1691,7 @@ enum compact_result try_to_compact_pages
 
 	/*
 	 * Check if the GFP flags allow compaction - GFP_NOIO is really
-	 * tricky context because the migration might require IO and
+	 * tricky context because the migration might require IO
 	 */
 	if (!may_perform_io)
 		return COMPACT_SKIPPED;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-allow-compaction-for-gfp_nofs-requests.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

