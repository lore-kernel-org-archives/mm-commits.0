From: akpm@linux-foundation.org
Subject: [folded] cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 02 Feb 2010 14:14:11 -0800
Message-ID: <201002022214.o12MEB7A017576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab0BBWO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2010 17:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, jocelyn.falempe@motorola.com, mike@android.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch

This patch was dropped because it was folded into cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#36: FILE: drivers/cpufreq/cpufreq_ondemand.c:611:
+ ^I^Idelay -= jiffies % delay;$

total: 1 errors, 0 warnings, 20 lines checked

./patches/cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Jocelyn Falempe <jocelyn.falempe@motorola.com>
Cc: Mike Chan <mike@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -608,7 +608,7 @@ static inline void dbs_timer_init(struct
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
 	if (num_online_cpus() > 1)
- 		delay -= jiffies % delay;
+		delay -= jiffies % delay;
 
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh-fix.patch
drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
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
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
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

