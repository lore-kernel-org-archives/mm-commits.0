From: akpm@linux-foundation.org
Subject: [folded] thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 11:18:18 -0700
Message-ID: <20120529181818.7D1B0A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65007 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2E2SSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 14:18:20 -0400
Received: by were53 with SMTP id e53so258929wer.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 11:18:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix
has been removed from the -mm tree.  Its filename was
     thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch

This patch was dropped because it was folded into thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix

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

 drivers/thermal/exynos_thermal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix
+++ a/drivers/thermal/exynos_thermal.c
@@ -276,7 +276,7 @@ static int exynos_bind(struct thermal_zo
 		if (cdev == th_zone->cool_dev[i])
 			break;
 
-	/*No matching cooling device*/
+	/* No matching cooling device */
 	if (i == th_zone->cool_dev_size)
 		return 0;
 
@@ -306,7 +306,7 @@ static int exynos_unbind(struct thermal_
 		if (cdev == th_zone->cool_dev[i])
 			break;
 
-	/*No matching cooling device*/
+	/* No matching cooling device */
 	if (i == th_zone->cool_dev_size)
 		return 0;
 
@@ -746,7 +746,7 @@ static int __devinit exynos_tmu_probe(st
 
 	exynos_tmu_control(pdev, true);
 
-	/*Register the sensor with thermal management interface*/
+	/* Register the sensor with thermal management interface */
 	(&exynos_sensor_conf)->private_data = data;
 	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
 			pdata->trigger_level1_en + pdata->trigger_level2_en +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
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
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
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
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
fs-nls-add-apple-nls-fix.patch
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

