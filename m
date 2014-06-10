From: akpm@linux-foundation.org
Subject: + sysctl-remove-now-unused-typedef-ctl_table-fix.patch added to
 -mm tree
Date: Tue, 10 Jun 2014 16:18:04 -0700
Message-ID: <5397922c.a7JY9ba1RmdhtLY/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaFJXSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + sysctl-remove-now-unused-typedef-ctl_table-fix.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:18:04 -0700


The patch titled
     Subject: sysctl-remove-now-unused-typedef-ctl_table-fix
has been added to the -mm tree.  Its filename is
     sysctl-remove-now-unused-typedef-ctl_table-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-remove-now-unused-typedef-ctl_table-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-remove-now-unused-typedef-ctl_table-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sysctl-remove-now-unused-typedef-ctl_table-fix

Not so fast buckwheat.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table-fix fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table-fix
+++ a/fs/proc/proc_sysctl.c
@@ -632,7 +632,7 @@ out:
 	return ret;
 }
 
-static int scan(struct ctl_table_header *head, ctl_table *table,
+static int scan(struct ctl_table_header *head, struct ctl_table *table,
 		unsigned long *pos, struct file *file,
 		struct dir_context *ctx)
 {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
linux-next.patch

