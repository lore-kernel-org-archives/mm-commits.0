From: akpm@linux-foundation.org
Subject: [merged] drivers-parport-parport_pcc-fix-warnings.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:46 -0800
Message-ID: <20120113203646.EB77B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:48 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/parport/parport_pc.c: fix warnings
has been removed from the -mm tree.  Its filename was
     drivers-parport-parport_pcc-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/parport/parport_pc.c: fix warnings

drivers/parport/parport_pc.c: In function '__check_irq':
drivers/parport/parport_pc.c:3415: warning: return from incompatible pointer type
drivers/parport/parport_pc.c: In function '__check_dma':
drivers/parport/parport_pc.c:3417: warning: return from incompatible pointer type


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/parport_pc.c~drivers-parport-parport_pcc-fix-warnings drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~drivers-parport-parport_pcc-fix-warnings
+++ a/drivers/parport/parport_pc.c
@@ -3404,8 +3404,8 @@ static int __init parport_init_mode_setu
 #endif
 
 #ifdef MODULE
-static const char *irq[PARPORT_PC_MAX_PORTS];
-static const char *dma[PARPORT_PC_MAX_PORTS];
+static char *irq[PARPORT_PC_MAX_PORTS];
+static char *dma[PARPORT_PC_MAX_PORTS];
 
 MODULE_PARM_DESC(io, "Base I/O address (SPP regs)");
 module_param_array(io, int, NULL, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

