From: akpm@linux-foundation.org
Subject: [merged] auditsc-fix-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:57 -0700
Message-ID: <200904061939.n36Jdvp8014116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbZDFTnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     auditsc: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     auditsc-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

