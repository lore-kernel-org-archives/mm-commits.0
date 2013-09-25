From: akpm@linux-foundation.org
Subject: + kernel-auditc-remove-duplicated-comment.patch added to -mm tree
Date: Wed, 25 Sep 2013 15:13:06 -0700
Message-ID: <52435ff2.lRuT5wQBLH3CgRO+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3IYWNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 18:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, eparis@redhat.com, casey@schaufler-ca.com, gaofeng@cn.fujitsu.com

Subject: + kernel-auditc-remove-duplicated-comment.patch added to -mm tree
To: gaofeng@cn.fujitsu.com,casey@schaufler-ca.com,eparis@redhat.com,rgb@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 15:13:06 -0700


The patch titled
     Subject: kernel/audit.c: remove duplicated comment
has been added to the -mm tree.  Its filename is
     kernel-auditc-remove-duplicated-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-auditc-remove-duplicated-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-auditc-remove-duplicated-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: kernel/audit.c: remove duplicated comment

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN kernel/audit.c~kernel-auditc-remove-duplicated-comment kernel/audit.c
--- a/kernel/audit.c~kernel-auditc-remove-duplicated-comment
+++ a/kernel/audit.c
@@ -1067,13 +1067,6 @@ static void wait_for_auditd(unsigned lon
 	remove_wait_queue(&audit_backlog_wait, &wait);
 }
 
-/* Obtain an audit buffer.  This routine does locking to obtain the
- * audit buffer, but then no locking is required for calls to
- * audit_log_*format.  If the tsk is a task that is currently in a
- * syscall, then the syscall is marked as auditable and an audit record
- * will be written at syscall exit.  If there is no associated task, tsk
- * should be NULL. */
