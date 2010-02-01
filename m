From: akpm@linux-foundation.org
Subject: [to-be-updated] cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix.patch removed from -mm tree
Date: Mon, 01 Feb 2010 11:37:16 -0800
Message-ID: <201002011937.o11JbGAL007866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845Ab0BATjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 14:39:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, mike@android.com, trenn@suse.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix
has been removed from the -mm tree.  Its filename was
     cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix printk output.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mike Chan <mike@android.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -331,7 +331,7 @@ static ssize_t store_ignore_nice_load(st
 	unsigned int input;
 	unsigned int j;
 
-	printk_once(KERN_INFO "CPUFREQ: ondemand ignore_nice_load"
+	printk_once(KERN_INFO "CPUFREQ: ondemand ignore_nice_load() "
 	       "sysfs file is deprecated - use nice_max_freq instead");
 
 	if (sscanf(buf, "%u", &input) != 1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

