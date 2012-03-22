From: akpm@linux-foundation.org
Subject: [merged] memcg-kill-dead-prev_priority-stubs.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:48 -0700
Message-ID: <20120322201948.59E21A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34424 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:49 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so403323yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: kill dead prev_priority stubs
has been removed from the -mm tree.  Its filename was
     memcg-kill-dead-prev_priority-stubs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: memcg: kill dead prev_priority stubs

This code was removed in v2.6.35-5854-g25edde0
("vmscan: kill prev_priority completely")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-kill-dead-prev_priority-stubs include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-kill-dead-prev_priority-stubs
+++ a/include/linux/memcontrol.h
@@ -299,21 +299,6 @@ static inline void mem_cgroup_iter_break
 {
 }
 
-static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
-static inline void mem_cgroup_note_reclaim_priority(struct mem_cgroup *memcg,
-						int priority)
-{
-}
-
-static inline void mem_cgroup_record_reclaim_priority(struct mem_cgroup *memcg,
-						int priority)
-{
-}
