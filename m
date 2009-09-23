From: akpm@linux-foundation.org
Subject: [merged] drivers-video-tmiofbc-fix-uninitialised-return-value.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:22 -0700
Message-ID: <200909232003.n8NK3M3X019051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbZIWUJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/tmiofb.c: fix uninitialised return value
has been removed from the -mm tree.  Its filename was
     drivers-video-tmiofbc-fix-uninitialised-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/tmiofb.c: fix uninitialised return value
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/tmiofb.c: In function 'tmiofb_resume':
drivers/video/tmiofb.c:977: warning: 'retval' may be used uninitialized in this function

Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tmiofb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tmiofb.c~drivers-video-tmiofbc-fix-uninitialised-return-value drivers/video/tmiofb.c
--- a/drivers/video/tmiofb.c~drivers-video-tmiofbc-fix-uninitialised-return-value
+++ a/drivers/video/tmiofb.c
@@ -974,7 +974,7 @@ static int tmiofb_resume(struct platform
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct mfd_cell *cell = dev->dev.platform_data;
-	int retval;
+	int retval = 0;
 
 	acquire_console_sem();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
drivers-md-dm-log-userspace-basec-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-linux-credh-fix-build.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-usb-serial-sierrac-fix-config_pm=n-build.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
hugetlb_file_setup-use-c-not-cpp.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-arch-frv-kernel-debug-stubc-needs-start_kernelh.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-smpc-relocate-some-code.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
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

