From: akpm@linux-foundation.org
Subject: + rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch added to -mm tree
Date: Fri, 26 Jun 2009 15:59:27 -0700
Message-ID: <200906262259.n5QMxRt0019483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbZFZW7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 18:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, daniel@caiaq.de, s.hauer@pengutronix.de


The patch titled
     rtc-add-driver-for-mxcs-internal-rtc-module-fix
has been added to the -mm tree.  Its filename is
     rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-add-driver-for-mxcs-internal-rtc-module-fix
From: Andrew Morton <akpm@linux-foundation.org>

Make PIE_BIT_DEF[] static

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-add-driver-for-mxcs-internal-rtc-module-fix drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-add-driver-for-mxcs-internal-rtc-module-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -42,7 +42,7 @@
 
 #define MAX_PIE_NUM     9
 #define MAX_PIE_FREQ    512
-const u32 PIE_BIT_DEF[MAX_PIE_NUM][2] = {
+statix const u32 PIE_BIT_DEF[MAX_PIE_NUM][2] = {
 	{ 2,		RTC_2HZ_BIT },
 	{ 4,		RTC_SAM0_BIT },
 	{ 8,		RTC_SAM1_BIT },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-dont-implement-per_cpu_attributes.patch
drivers-net-usb-usbnetc-fix-proc-net-dev-stats.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

