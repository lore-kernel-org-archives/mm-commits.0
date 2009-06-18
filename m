From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unneeded-forward-declaration-from-schedh.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:03 -0700
Message-ID: <200906182246.n5IMk32R005099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbZFRWqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove unneeded forward declaration from sched.h
has been removed from the -mm tree.  Its filename was
     memcg-remove-unneeded-forward-declaration-from-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

