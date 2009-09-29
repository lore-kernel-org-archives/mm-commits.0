From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch removed from -mm tree
Date: Tue, 29 Sep 2009 12:13:49 -0700
Message-ID: <200909291913.n8TJDndB030853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbZI2TOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chunkeey@googlemail.com, chunkeey@web.de, davem@davemloft.net, jal2@gmx.de, linville@tuxdriver.com, lrodriguez@atheros.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/ath/ar9170/phy.c: fix uninitialised variable
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/ath/ar9170/phy.c: fix uninitialised variable
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/wireless/ath/ar9170/phy.c: In function 'ar9170_set_channel':
drivers/net/wireless/ath/ar9170/phy.c:1211: warning: 'phy_data' may be used uninitialized in this function

Cc: Christian Lamparter <chunkeey@web.de>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joerg Albert <jal2@gmx.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/ar9170/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/ath/ar9170/phy.c~drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable drivers/net/wireless/ath/ar9170/phy.c
--- a/drivers/net/wireless/ath/ar9170/phy.c~drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable
+++ a/drivers/net/wireless/ath/ar9170/phy.c
@@ -1208,7 +1208,7 @@ static int ar9170_set_freq_cal_data(stru
 		}
 
 		for (i = 0; i < 76; i++) {
-			u32 phy_data;
+			u32 phy_data = 0;
 			u8 tmp;
 
 			if (i < 25) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-input-inputc-fix-config_pm=n-warning.patch
sparc32-convert-to-asm-generic-hardirqh.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
ar9170-fix-bug-in-iq-auto-calibration-value-calculation.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
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

