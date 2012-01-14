From: akpm@linux-foundation.org
Subject: + prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:36:07 -0800
Message-ID: <20120114003608.850C05C006B@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42507 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545Ab2ANAgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:36:10 -0500
Received: by eeke50 with SMTP id e50so28937eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:36:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, lennart@poettering.net, oleg@redhat.com


The patch titled
     Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix
has been added to the -mm tree.  Its filename is
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix

fix comment layout and spelling

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix
+++ a/kernel/exit.c
@@ -687,10 +687,9 @@ static void exit_mm(struct task_struct *
 
 /*
  * When we die, we re-parent all our children, and try to:
- * 1. give them to another thread in our thread group, if such a
- *    member exists
- * 2. give it to the first anchestor process which prctl'd itself
- *    as a child_subreaper for its children (like a service manager)
+ * 1. give them to another thread in our thread group, if such a member exists
+ * 2. give it to the first ancestor process which prctl'd itself as a
+ *    child_subreaper for its children (like a service manager)
  * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
_
Subject: Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-warnings-regarding-enum-migrate_mode.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
audit-treat-s_id-as-an-untrusted-string.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch

