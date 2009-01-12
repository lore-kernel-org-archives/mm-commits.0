From: akpm@linux-foundation.org
Subject: + auditsc-fix-kernel-doc-notation.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:49:07 -0800
Message-ID: <200901122249.n0CMn7PO013049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760990AbZALWto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     auditsc: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     auditsc-fix-kernel-doc-notation.patch

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
Subject: auditsc: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auditsc kernel-doc notation:

Warning(linux-2.6.28-git7//kernel/auditsc.c:2156): No description found for parameter 'attr'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2156): Excess function parameter 'u_attr' description in '__audit_mq_open'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2204): No description found for parameter 'notification'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2204): Excess function parameter 'u_notification' description in '__audit_mq_notify'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~auditsc-fix-kernel-doc-notation kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-fix-kernel-doc-notation
+++ a/kernel/auditsc.c
@@ -2149,7 +2149,7 @@ int audit_set_loginuid(struct task_struc
  * __audit_mq_open - record audit data for a POSIX MQ open
  * @oflag: open flag
  * @mode: mode bits
- * @u_attr: queue attributes
+ * @attr: queue attributes
  *
  */
 void __audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr)
@@ -2196,7 +2196,7 @@ void __audit_mq_sendrecv(mqd_t mqdes, si
 /**
  * __audit_mq_notify - record audit data for a POSIX MQ notify
  * @mqdes: MQ descriptor
- * @u_notification: Notification event
+ * @notification: Notification event
  *
  */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

