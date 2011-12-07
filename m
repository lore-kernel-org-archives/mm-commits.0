From: akpm@linux-foundation.org
Subject: + drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch added to -mm tree
Date: Wed, 07 Dec 2011 15:25:17 -0800
Message-ID: <201112072325.pB7NPIFv019294@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41170 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab1LGXZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 18:25:22 -0500
Received: by eekc14 with SMTP id c14so24779eek.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 15:25:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, john@Calva.COMjohn@Calva.COM, john@calvaedi.com, malattia@linux.it, mjg@redhat.com


The patch titled
     Subject: drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes

Cc: Dan Carpenter <dan.carpenter@oracle.com>

ERROR: code indent should use tabs where possible
#34: FILE: drivers/platform/x86/sony-laptop.c:395:
+                   remap the key */$

total: 1 errors, 0 warnings, 28 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/drivers-platform-x86-sony-laptopc-fix-scancodes-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Hughes <john@Calva.COM>
Cc: John Hughes <john@calva.com>
Cc: John Hughes <john@calvaedi.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/sony-laptop.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes
+++ a/drivers/platform/x86/sony-laptop.c
@@ -391,8 +391,10 @@ static void sony_laptop_report_input_eve
 	}
 
 	if (kp.dev) {
-		/* if we have a scancode we emit it so we can always
-                   remap the key */
+		/*
+		 * If we have a scancode we emit it so we can always remap the
+		 * key
+		 */
 		if (scancode != -1)
 			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
_
Subject: Subject: drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

