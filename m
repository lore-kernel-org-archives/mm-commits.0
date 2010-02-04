From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:16 -0800
Message-ID: <201002041749.o14HnGlE012021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0BDRto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, awalls@radix.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cx18/cx18-alsa-pcm.c: fix printk warning
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/cx18/cx18-alsa-pcm.c: fix printk warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/cx18/cx18-alsa-pcm.c: In function 'cx18_alsa_announce_pcm_data':
drivers/media/video/cx18/cx18-alsa-pcm.c:82: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Acked-by: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx18/cx18-alsa-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning drivers/media/video/cx18/cx18-alsa-pcm.c
--- a/drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning
+++ a/drivers/media/video/cx18/cx18-alsa-pcm.c
@@ -79,7 +79,7 @@ void cx18_alsa_announce_pcm_data(struct 
 	int period_elapsed = 0;
 	int length;
 
-	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%d\n", cxsc,
+	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%zd\n", cxsc,
 		pcm_data, num_bytes);
 
 	substream = cxsc->capture_pcm_substream;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

