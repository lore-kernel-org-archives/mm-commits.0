From: akpm@linux-foundation.org
Subject: + sched-fix-kernel-doc-warnings.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:06:20 -0700
Message-ID: <200707290706.l6T76KO2012895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759887AbXG2HHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     sched: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     sched-fix-kernel-doc-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in sched.c:

Warning(linux-2623-rc1g4//kernel/sched.c:1685): No description found for parameter 'notifier'
Warning(linux-2623-rc1g4//kernel/sched.c:1696): No description found for parameter 'notifier'
Warning(linux-2623-rc1g4//kernel/sched.c:1750): No description found for parameter 'prev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-fix-kernel-doc-warnings kernel/sched.c
--- a/kernel/sched.c~sched-fix-kernel-doc-warnings
+++ a/kernel/sched.c
@@ -1678,8 +1678,8 @@ void fastcall wake_up_new_task(struct ta
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
- * preempt_notifier_register - tell me when current is being being preempted
- *                         and rescheduled
+ * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
 {
@@ -1689,6 +1689,7 @@ EXPORT_SYMBOL_GPL(preempt_notifier_regis
 
 /**
  * preempt_notifier_unregister - no longer interested in preemption notifications
+ * @notifier: notifier struct to unregister
  *
  * This is safe to call from within a preemption notifier.
  */
@@ -1735,6 +1736,7 @@ fire_sched_out_preempt_notifiers(struct 
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
+ * @prev: the current task that is being switched out
  * @next: the task we are going to switch to.
  *
  * This is called with the rq lock held and interrupts off. It must
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
pnp-fix-kernel-doc-warnings.patch
sched-fix-kernel-doc-warnings.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
