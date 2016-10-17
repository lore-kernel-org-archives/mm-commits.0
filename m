From: akpm@linux-foundation.org
Subject: + mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
 added to -mm tree
Date: Mon, 17 Oct 2016 14:36:58 -0700
Message-ID: <5805447a.ax0XUMSAokvoxtp4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56999 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934166AbcJQVg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 17:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fromorbit.com, js1304@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-allow-compaction-for-gfp_nofs-requests-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1710,7 +1710,7 @@ enum compact_result try_to_compact_pages
 
 	/*
 	 * Check if the GFP flags allow compaction - GFP_NOIO is really
-	 * tricky context because the migration might require IO and
+	 * tricky context because the migration might require IO
 	 */
 	if (!may_perform_io)
 		return COMPACT_SKIPPED;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

