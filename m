From: akpm@linux-foundation.org
Subject: + prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch added to -mm tree
Date: Thu, 19 Jan 2012 12:41:10 -0800
Message-ID: <20120119212336.7894E10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51616 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2ASVXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 16:23:37 -0500
Received: by yenr8 with SMTP id r8so40604yen.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 13:23:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, lennart@poettering.net, oleg@redhat.com


The patch titled
     Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix
has been added to the -mm tree.  Its filename is
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch

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
Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix

fix conflict with PR_SET_MM

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix
+++ a/include/linux/prctl.h
@@ -114,7 +114,7 @@
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
 
-#define PR_SET_CHILD_SUBREAPER 35
-#define PR_GET_CHILD_SUBREAPER 36
+#define PR_SET_CHILD_SUBREAPER 36
+#define PR_GET_CHILD_SUBREAPER 37
 
 #endif /* _LINUX_PRCTL_H */
_
Subject: Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix

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
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

