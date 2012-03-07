From: akpm@linux-foundation.org
Subject: + mm-vmscanc-fix-spelling-error.patch added to -mm tree
Date: Tue, 06 Mar 2012 16:31:48 -0800
Message-ID: <20120307003148.89C2EA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37649 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2CGAbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 19:31:49 -0500
Received: by ghbz15 with SMTP id z15so719805ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 16:31:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.mihai.c@gmail.com


The patch titled
     Subject: mm/vmscan.c: fix spelling error
has been added to the -mm tree.  Its filename is
     mm-vmscanc-fix-spelling-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/vmscan.c: fix spelling error

Patches currently in -mm which might be from alex.mihai.c@gmail.com are

mm-vmscanc-fix-spelling-error.patch

