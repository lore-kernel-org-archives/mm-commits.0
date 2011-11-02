From: akpm@linux-foundation.org
Subject: [folded] memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:16:19 -0700
Message-ID: <201111022016.pA2KGK4i023389@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:57528 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1KBUQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-skip-scanning-active-lists-based-on-individual-size-fix
has been removed from the -mm tree.  Its filename was
     memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

This patch was dropped because it was folded into memcg-skip-scanning-active-lists-based-on-individual-size.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: memcg-skip-scanning-active-lists-based-on-individual-size-fix

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

origin.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-close-race-between-charge-and-putback.patch

