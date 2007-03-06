From: akpm@linux-foundation.org
Subject: - setstream-param-for-psmouse-tweak.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:35:11 -0800
Message-ID: <200703061035.l26AZBLm019396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34261 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017AbXCFKfd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:35:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@suse.de, dtor@mail.ru, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     setstream-param-for-psmouse-tweak
has been removed from the -mm tree.  Its filename was
     setstream-param-for-psmouse-tweak.patch

This patch was dropped because it was folded into setstream-param-for-psmouse.patch

------------------------------------------------------
Subject: setstream-param-for-psmouse-tweak
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse-tweak drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~setstream-param-for-psmouse-tweak
+++ a/drivers/input/mouse/psmouse-base.c
@@ -69,9 +69,9 @@ MODULE_PARM_DESC(resync_time, "How long 
  * The setstream parameter is needed if you have an ACK 580 that stops
  * streaming if you ever enable the streaming mode explicitly.
  */
-static unsigned int psmouse_setstream = 1;
+static unsigned int psmouse_setstream;
 module_param_named(setstream, psmouse_setstream, uint, 0644);
-MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled (default), 0 = disabled.");
+MODULE_PARM_DESC(setstream, "Turn on streaming mode explicitly, 1 = enabled, 0 = disabled (default).");
 
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
 			NULL,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
setstream-param-for-psmouse.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
