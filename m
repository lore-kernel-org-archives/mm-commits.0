From: akpm@linux-foundation.org
Subject: - ivtv-warning-fix.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:18 -0800
Message-ID: <200703152157.l2FLvIKT027626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXCOV5Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ivtv warning fix
has been removed from the -mm tree.  Its filename was
     ivtv-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ivtv warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/ivtv/ivtv-i2c.c:547: warning: initializer-string for array of chars is too long
drivers/media/video/ivtv/ivtv-i2c.c:547: warning: (near initialization for 'ivtv_i2c_client_template.name')

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ivtv/ivtv-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/ivtv/ivtv-i2c.c~ivtv-warning-fix drivers/media/video/ivtv/ivtv-i2c.c
--- a/drivers/media/video/ivtv/ivtv-i2c.c~ivtv-warning-fix
+++ a/drivers/media/video/ivtv/ivtv-i2c.c
@@ -544,7 +544,7 @@ static struct i2c_algo_bit_data ivtv_i2c
 };
 
 static struct i2c_client ivtv_i2c_client_template = {
-	.name = "ivtv internal use only",
+	.name = "ivtv internal",
 };
 
 int ivtv_call_i2c_client(struct ivtv *itv, int addr, unsigned int cmd, void *arg)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-tidy.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
