From: akpm@linux-foundation.org
Subject: [withdrawn] n_hdlc-add-buffer-flushing-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 21 Jul 2009 15:20:11 -0700
Message-ID: <200907212220.n6LMKBYT030961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbZGUWVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 18:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     n_hdlc-add-buffer-flushing-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     n_hdlc-add-buffer-flushing-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: n_hdlc-add-buffer-flushing-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#67: FILE: drivers/char/n_hdlc.c:217:
+ ^Ispin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);$

total: 1 errors, 0 warnings, 94 lines checked

./patches/n_hdlc-add-buffer-flushing.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/n_hdlc.c~n_hdlc-add-buffer-flushing-checkpatch-fixes drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlc-add-buffer-flushing-checkpatch-fixes
+++ a/drivers/char/n_hdlc.c
@@ -215,7 +215,7 @@ static void flush_tx_queue(struct tty_st
 
 	while ((buf = n_hdlc_buf_get(&n_hdlc->tx_buf_list)))
 		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, buf);
- 	spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);
+	spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);
 	if (n_hdlc->tbuf) {
 		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, n_hdlc->tbuf);
 		n_hdlc->tbuf = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

