From: akpm@linux-foundation.org
Subject: [merged] drivers-char-randomc-fix-unused-var-warning.patch removed from -mm tree
Date: Tue, 02 Feb 2010 11:32:40 -0800
Message-ID: <201002021932.o12JWeC5009268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab0BBTdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2010 14:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, herbert@gondor.apana.org.au, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/random.c: fix unused var warning
has been removed from the -mm tree.  Its filename was
     drivers-char-randomc-fix-unused-var-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/random.c: fix unused var warning
From: Andrew Morton <akpm@linux-foundation.org>

Repair

: commit b9b06a1fda275559492f8b083927fde4cec641dc
: Author:     Herbert Xu <herbert@gondor.apana.org.au>
: AuthorDate: Fri Jan 29 21:50:36 2010 +1300
: Commit:     Herbert Xu <herbert@gondor.apana.org.au>
: CommitDate: Fri Jan 29 21:50:36 2010 +1300
: 
:     random: drop weird m_time/a_time manipulation
    

Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/random.c~drivers-char-randomc-fix-unused-var-warning drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomc-fix-unused-var-warning
+++ a/drivers/char/random.c
@@ -1101,7 +1101,6 @@ static ssize_t random_write(struct file 
 			    size_t count, loff_t *ppos)
 {
 	size_t ret;
-	struct inode *inode = file->f_path.dentry->d_inode;
 
 	ret = write_pool(&blocking_pool, buffer, count);
 	if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
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

