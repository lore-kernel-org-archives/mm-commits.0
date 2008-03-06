From: akpm@linux-foundation.org
Subject: + typo-in-documentation-scheduler-sched-statstxt.patch added to -mm tree
Date: Wed, 05 Mar 2008 23:15:52 -0800
Message-ID: <200803060715.m267FqhQ014261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbYCFHQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 02:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yamato@redhat.com, mingo@elte.hu


The patch titled
     Typo in Documentation/scheduler/sched-stats.txt
has been added to the -mm tree.  Its filename is
     typo-in-documentation-scheduler-sched-statstxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Typo in Documentation/scheduler/sched-stats.txt
From: Masatake YAMATO <yamato@redhat.com>

I have found a very small typo in Documentation/scheduler/sched-stats.txt.
See the end of this mail.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scheduler/sched-stats.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/scheduler/sched-stats.txt~typo-in-documentation-scheduler-sched-statstxt Documentation/scheduler/sched-stats.txt
--- a/Documentation/scheduler/sched-stats.txt~typo-in-documentation-scheduler-sched-statstxt
+++ a/Documentation/scheduler/sched-stats.txt
@@ -142,7 +142,7 @@ of idleness (idle, busy, and newly idle)
 
 /proc/<pid>/schedstat
 ----------------
-schedstats also adds a new /proc/<pid/schedstat file to include some of
+schedstats also adds a new /proc/<pid>/schedstat file to include some of
 the same information on a per-process level.  There are three fields in
 this file correlating for that process to:
      1) time spent on the cpu
_

Patches currently in -mm which might be from yamato@redhat.com are

typo-in-documentation-scheduler-sched-statstxt.patch

