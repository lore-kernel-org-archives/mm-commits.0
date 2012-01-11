From: akpm@linux-foundation.org
Subject: + drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch added to -mm tree
Date: Wed, 11 Jan 2012 14:30:24 -0800
Message-ID: <20120111223024.D341810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39340 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKWa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:30:26 -0500
Received: by yhpp56 with SMTP id p56so161253yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 14:30:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, aradford@gmail.com, megaraidlinux@lsi.com, rdunlap@xenotime.net


The patch titled
     Subject: drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch

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
Subject: Subject: drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-nfs-nfs4procc-fix-printk-warnings.patch
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
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

