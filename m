From: akpm@linux-foundation.org
Subject: [merged] mm-vmscanc-fix-spelling-error.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:51 -0700
Message-ID: <20120322201851.526C3A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56636 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2CVUSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:52 -0400
Received: by ggnd2 with SMTP id d2so401558ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.mihai.c@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix spelling error
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fix-spelling-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Copot Alexandru <alex.mihai.c@gmail.com>
Subject: mm/vmscan.c: fix spelling error

s/noticable/noticeable/

Signed-off-by: Copot Alexandru <alex.mihai.c@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-fix-spelling-error mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-fix-spelling-error
+++ a/mm/vmscan.c
@@ -2261,8 +2261,8 @@ static bool shrink_zones(int priority, s
 				 * Even though compaction is invoked for any
 				 * non-zero order, only frequent costly order
 				 * reclamation is disruptive enough to become a
-				 * noticable problem, like transparent huge page
-				 * allocations.
+				 * noticeable problem, like transparent huge
+				 * page allocations.
 				 */
 				if (compaction_ready(zone, sc)) {
 					aborted_reclaim = true;
_

Patches currently in -mm which might be from alex.mihai.c@gmail.com are

origin.patch

