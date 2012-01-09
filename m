From: akpm@linux-foundation.org
Subject: + drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch added to -mm tree
Date: Mon, 09 Jan 2012 14:59:52 -0800
Message-ID: <20120109234205.11F98200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:56321 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2AIXmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 18:42:08 -0500
Received: by wgbdt14 with SMTP id dt14so77989wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 15:42:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
has been added to the -mm tree.  Its filename is
     drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch

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
Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5744,7 +5744,7 @@ _scsih_sas_enclosure_dev_status_change_e
 }
 
 /**
- * _scsih_sas_broadcast_primative_event - handle broadcast events
+ * _scsih_sas_broadcast_primitive_event - handle broadcast events
  * @ioc: per adapter object
  * @fw_event: The fw_event_work object
  * Context: user.
@@ -5752,7 +5752,7 @@ _scsih_sas_enclosure_dev_status_change_e
  * Return nothing.
  */
 static void
-_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
+_scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
@@ -7263,7 +7263,7 @@ _firmware_event_work(struct work_struct 
 		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		_scsih_sas_broadcast_primative_event(ioc,
+		_scsih_sas_broadcast_primitive_event(ioc,
 		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
_
Subject: Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
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

