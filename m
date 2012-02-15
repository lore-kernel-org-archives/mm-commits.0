From: akpm@linux-foundation.org
Subject: + memcg-kill-dead-prev_priority-stubs.patch added to -mm tree
Date: Wed, 15 Feb 2012 13:15:41 -0800
Message-ID: <20120215211541.49841A01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58480 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2BOVPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 16:15:42 -0500
Received: by yenm1 with SMTP id m1so205671yen.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 13:15:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: memcg: kill dead prev_priority stubs
has been added to the -mm tree.  Its filename is
     memcg-kill-dead-prev_priority-stubs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
