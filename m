From: akpm@linux-foundation.org
Subject: [merged] sound-pci-hda-patch_viac-work-around-gcc-402-ice.patch removed from -mm tree
Date: Mon, 16 Nov 2009 11:04:22 -0800
Message-ID: <200911161904.nAGJ4MG8015316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbZKPTEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 14:04:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/pci/hda/patch_via.c: work around gcc-4.0.2 ICE
has been removed from the -mm tree.  Its filename was
     sound-pci-hda-patch_viac-work-around-gcc-402-ice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/pci/hda/patch_via.c: work around gcc-4.0.2 ICE
From: Andrew Morton <akpm@linux-foundation.org>

sound/pci/hda/patch_via.c: In function 'via_hp_bind_automute':
sound/pci/hda/patch_via.c:2074: internal compiler error: in do_SUBST, at combine.c:462
Please submit a full bug report,
with preprocessed source if appropriate.
See <URL:http://gcc.gnu.org/bugs.html> for instructions.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_via.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/hda/patch_via.c~sound-pci-hda-patch_viac-work-around-gcc-402-ice sound/pci/hda/patch_via.c
--- a/sound/pci/hda/patch_via.c~sound-pci-hda-patch_viac-work-around-gcc-402-ice
+++ a/sound/pci/hda/patch_via.c
@@ -2043,7 +2043,7 @@ static void via_speaker_automute(struct 
 /* mute line-out and internal speaker if HP is plugged */
 static void via_hp_bind_automute(struct hda_codec *codec)
 {
-	unsigned int hp_present, present = 0;
+	unsigned long hp_present, present = 0;
 	struct via_spec *spec = codec->spec;
 	int i;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
recordmcount-stfu.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-char-cycladesc-fix-used-uninitialised-bug.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
drivers-acpi-acpi_padc-squish-warning.patch
drivers-char-agp-amd64-agpc-squish-warning.patch
drm-kill-more-unused-drm-macros-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
drivers-atm-solos-pcic-fix-warning-bug-clean-up-code.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

