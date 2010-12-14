From: akpm@linux-foundation.org
Subject: + sysctl-remove-obsolete-comments.patch added to -mm tree
Date: Tue, 14 Dec 2010 13:36:54 -0800
Message-ID: <201012142136.oBELasMa011170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab0LNVhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 16:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bookjovi@gmail.com, hidave.darkstar@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     sysctl: remove obsolete comments
has been added to the -mm tree.  Its filename is
     sysctl-remove-obsolete-comments.patch

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
Subject: sysctl: remove obsolete comments
From: Jovi Zhang <bookjovi@gmail.com>

ctl_unnumbered.txt have been removed in Documentation directory so just
also remove this invalid comments

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-obsolete-comments kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-obsolete-comments
+++ a/kernel/sysctl.c
@@ -245,10 +245,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -962,10 +958,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1326,11 +1318,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1486,10 +1473,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
_

Patches currently in -mm which might be from bookjovi@gmail.com are

linux-next.patch
proc-use-single_open-correctly.patch
sysctl-fix-ifdef-guard-comment.patch
sysctl-remove-obsolete-comments.patch
sysctl-remove-obsolete-comments-fix.patch

