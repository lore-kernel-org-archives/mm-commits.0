From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-nmi_selftestc-needs-percpuh.patch added to -mm tree
Date: Thu, 19 Jan 2012 13:25:32 -0800
Message-ID: <20120119220759.0F87D20005F@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64965 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2ASWIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 17:08:01 -0500
Received: by eaaf1 with SMTP id f1so13596eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 14:08:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: arch/x86/kernel/nmi_selftest.c needs percpu.h
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-nmi_selftestc-needs-percpuh.patch

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
Subject: arch/x86/kernel/nmi_selftest.c needs percpu.h

x86_64 allmodconfig:

arch/x86/kernel/nmi_selftest.c: In function 'test_nmi_ipi_callback':
arch/x86/kernel/nmi_selftest.c:53: error: implicit declaration of function 'this_cpu_read'

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/nmi_selftest.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/nmi_selftest.c~arch-x86-kernel-nmi_selftestc-needs-percpuh arch/x86/kernel/nmi_selftest.c
--- a/arch/x86/kernel/nmi_selftest.c~arch-x86-kernel-nmi_selftestc-needs-percpuh
+++ a/arch/x86/kernel/nmi_selftest.c
@@ -12,6 +12,7 @@
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/delay.h>
+#include <linux/percpu.h>
 
 #include <asm/apic.h>
 #include <asm/nmi.h>
_
Subject: Subject: arch/x86/kernel/nmi_selftest.c needs percpu.h

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-warnings-regarding-enum-migrate_mode.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-kernel-nmi_selftestc-needs-percpuh.patch
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

