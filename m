From: akpm@linux-foundation.org
Subject: - typo-in-documentation-scheduler-sched-statstxt.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:05 -0700
Message-ID: <200803110322.m2B3M5gc019781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbYCKDWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamato@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Typo in Documentation/scheduler/sched-stats.txt
has been removed from the -mm tree.  Its filename was
     typo-in-documentation-scheduler-sched-statstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

