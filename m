From: akpm@linux-foundation.org
Subject: [merged] kernel-auditc-remove-duplicated-comment.patch removed
 from -mm tree
Date: Thu, 07 Nov 2013 11:08:27 -0800
Message-ID: <527be52b.p7fOkOcQX36iVanL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3KGTI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 14:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, eparis@redhat.com, casey@schaufler-ca.com, gaofeng@cn.fujitsu.com

Subject: [merged] kernel-auditc-remove-duplicated-comment.patch removed from -mm tree
To: gaofeng@cn.fujitsu.com,casey@schaufler-ca.com,eparis@redhat.com,rgb@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 11:08:27 -0800


The patch titled
     Subject: kernel/audit.c: remove duplicated comment
has been removed from the -mm tree.  Its filename was
     kernel-auditc-remove-duplicated-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
