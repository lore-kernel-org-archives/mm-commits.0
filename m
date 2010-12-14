From: akpm@linux-foundation.org
Subject: + sysctl-fix-ifdef-guard-comment.patch added to -mm tree
Date: Tue, 14 Dec 2010 13:36:52 -0800
Message-ID: <201012142136.oBELaqZo011165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab0LNVhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 16:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bookjovi@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     sysctl: fix #ifdef guard comment
has been added to the -mm tree.  Its filename is
     sysctl-fix-ifdef-guard-comment.patch

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
@@ -2899,7 +2899,7 @@ int proc_do_large_bitmap(struct ctl_tabl
 	}
 }
 
-#else /* CONFIG_PROC_FS */
+#else /* CONFIG_PROC_SYSCTL */
 
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -2951,7 +2951,7 @@ int proc_doulongvec_ms_jiffies_minmax(st
 }
 
 
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_PROC_SYSCTL */
 
 /*
  * No sense putting this after each symbol definition, twice,
_

Patches currently in -mm which might be from bookjovi@gmail.com are

linux-next.patch
proc-use-single_open-correctly.patch
sysctl-fix-ifdef-guard-comment.patch
sysctl-remove-obsolete-comments.patch
sysctl-remove-obsolete-comments-fix.patch

