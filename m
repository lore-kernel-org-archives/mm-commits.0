From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:17 -0800
Message-ID: <20120117210118.7916B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63151 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2AQVBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:20 -0500
Received: by mail-fx0-f74.google.com with SMTP id p21so54354faa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, aradford@gmail.com, megaraidlinux@lsi.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes

Cc: <Bo.Yang@lsi.com>

ERROR: trailing whitespace
#28: FILE: drivers/scsi/megaraid.c:311:
+^I   right 8 bits making them zero. This 0 value was hardcoded to fix $

total: 1 errors, 0 warnings, 27 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/drivers-scsi-megaraidc-fix-sparse-warnings.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <Bo.Yang@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: adam radford <aradford@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes
+++ a/drivers/scsi/megaraid.c
@@ -308,7 +308,7 @@ mega_query_adapter(adapter_t *adapter)
 
 	/* use HP firmware and bios version encoding
 	   Note: fw_version[0|1] and bios_version[0|1] were originally shifted
-	   right 8 bits making them zero. This 0 value was hardcoded to fix 
+	   right 8 bits making them zero. This 0 value was hardcoded to fix
 	   sparse warnings. */
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
_

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
audit-treat-s_id-as-an-untrusted-string.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

