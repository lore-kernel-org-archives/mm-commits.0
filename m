From: akpm@linux-foundation.org
Subject: + thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch added to -mm tree
Date: Tue, 15 May 2012 14:01:45 -0700
Message-ID: <20120515210145.DF318A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:49962 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966786Ab2EOVBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:01:47 -0400
Received: by vbnl22 with SMTP id l22so8502vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:01:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com


The patch titled
     Subject: thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix
has been added to the -mm tree.  Its filename is
     thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch

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
Subject: thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix

fix comment layout

Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: SangWook Ju <sw.ju@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix
+++ a/drivers/thermal/exynos_thermal.c
@@ -39,7 +39,7 @@
 
 #include <plat/cpu.h>
 
-/*Exynos generic registers*/
+/* Exynos generic registers */
 #define EXYNOS_TMU_REG_TRIMINFO		0x0
 #define EXYNOS_TMU_REG_CONTROL		0x20
 #define EXYNOS_TMU_REG_STATUS		0x28
@@ -55,7 +55,7 @@
 #define EXYNOS_TMU_CORE_OFF		2
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET	50
 
-/*Exynos4 specific registers*/
+/* Exynos4 specific registers */
 #define EXYNOS4_TMU_REG_THRESHOLD_TEMP	0x44
 #define EXYNOS4_TMU_REG_TRIG_LEVEL0	0x50
 #define EXYNOS4_TMU_REG_TRIG_LEVEL1	0x54
@@ -72,7 +72,7 @@
 #define EXYNOS4_TMU_TRIG_LEVEL3_MASK	0x1000
 #define EXYNOS4_TMU_INTCLEAR_VAL	0x1111
 
-/*Exynos5 specific registers*/
+/* Exynos5 specific registers */
 #define EXYNOS5_TMU_TRIMINFO_CON	0x14
 #define EXYNOS5_THD_TEMP_RISE		0x50
 #define EXYNOS5_THD_TEMP_FALL		0x54
@@ -88,7 +88,7 @@
 #define EFUSE_MIN_VALUE 40
 #define EFUSE_MAX_VALUE 100
 
-/*In-kernel thermal framework related macros & definations*/
+/* In-kernel thermal framework related macros & definations */
 #define SENSOR_NAME_LEN	16
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
_
Subject: Subject: thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
perf-x86-fix-undefined-reference-to-get_ibs_caps.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation-fix.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

