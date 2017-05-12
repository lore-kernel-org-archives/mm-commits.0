From: akpm@linux-foundation.org
Subject: [folded-merged]
 hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch removed
 from -mm tree
Date: Fri, 12 May 2017 15:40:35 -0700
Message-ID: <591639e3.m35MuLlHo3S6zxdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdELWkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch

This patch was dropped because it was folded into hwpoison-memcg-forcibly-uncharge-lru-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#12: 
least not since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")). 

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#13: 
Each charge pins memcg (since e8ea14cc6ead ("mm: memcontrol: take a css

WARNING: line over 80 characters
#54: FILE: mm/memory-failure.c:544:
+		 * Poisoned page might never drop its ref count to 0 so we have to

total: 2 errors, 1 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/hwpoison-memcg-forcibly-uncharge-lru-pages.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes
+++ a/mm/memory-failure.c
@@ -541,8 +541,8 @@ static int delete_from_lru_cache(struct
 		ClearPageUnevictable(p);
 
 		/*
-		 * Poisoned page might never drop its ref count to 0 so we have to
-		 * uncharge it manually from its memcg.
+		 * Poisoned page might never drop its ref count to 0 so we have
+		 * to uncharge it manually from its memcg.
 		 */
 		mem_cgroup_uncharge(p);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hwpoison-memcg-forcibly-uncharge-lru-pages.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch

