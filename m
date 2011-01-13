From: akpm@linux-foundation.org
Subject: [merged] sysctl-fix-ifdef-guard-comment.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:05 -0800
Message-ID: <201101132011.p0DKBkvQ030201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933696Ab1AMUMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix #ifdef guard comment
has been removed from the -mm tree.  Its filename was
     sysctl-fix-ifdef-guard-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: fix #ifdef guard comment
From: Jovi Zhang <bookjovi@gmail.com>

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~sysctl-fix-ifdef-guard-comment kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-ifdef-guard-comment
+++ a/kernel/sysctl.c
@@ -2909,7 +2909,7 @@ int proc_do_large_bitmap(struct ctl_tabl
 	}
 }
 
-#else /* CONFIG_PROC_FS */
+#else /* CONFIG_PROC_SYSCTL */
 
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -2961,7 +2961,7 @@ int proc_doulongvec_ms_jiffies_minmax(st
 }
 
 
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_PROC_SYSCTL */
 
 /*
  * No sense putting this after each symbol definition, twice,
_

Patches currently in -mm which might be from bookjovi@gmail.com are

origin.patch
linux-next.patch

