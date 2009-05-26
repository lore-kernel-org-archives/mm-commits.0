From: akpm@linux-foundation.org
Subject: + memcg-remove-unneeded-forward-declaration-from-schedh.patch added to -mm tree
Date: Tue, 26 May 2009 16:29:46 -0700
Message-ID: <200905262329.n4QNTkQv007997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbZEZXag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove unneeded forward declaration from sched.h
has been added to the -mm tree.  Its filename is
     memcg-remove-unneeded-forward-declaration-from-schedh.patch

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
Subject: memcg: remove unneeded forward declaration from sched.h
From: Li Zefan <lizf@cn.fujitsu.com>

This forward declaration seems pointless.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/sched.h~memcg-remove-unneeded-forward-declaration-from-schedh include/linux/sched.h
--- a/include/linux/sched.h~memcg-remove-unneeded-forward-declaration-from-schedh
+++ a/include/linux/sched.h
@@ -92,7 +92,6 @@ struct sched_param {
 
 #include <asm/processor.h>
 
-struct mem_cgroup;
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cls_cgroup-read-classid-atomically-in-classifier.patch
cgroups-make-messages-more-readable.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch

