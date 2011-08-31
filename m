From: akpm@linux-foundation.org
Subject: + memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch added to -mm tree
Date: Wed, 31 Aug 2011 16:34:29 -0700
Message-ID: <201108312334.p7VNYTGY001864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab1HaXfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 19:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, minchan.kim@gmail.com


The patch titled
     memcg-skip-scanning-active-lists-based-on-individual-size-fix
has been added to the -mm tree.  Its filename is
     memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-skip-scanning-active-lists-based-on-individual-size-fix
From: Johannes Weiner <jweiner@redhat.com>

Also ditch the documentation note for the removed stats value.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-skip-scanning-active-lists-based-on-individual-size-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-skip-scanning-active-lists-based-on-individual-size-fix
+++ a/Documentation/cgroups/memory.txt
@@ -418,7 +418,6 @@ total_unevictable	- sum of all children'
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
-inactive_ratio		- VM internal parameter. (see mm/page_alloc.c)
 recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
 recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
 recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-remove-unneeded-preempt_disable.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

