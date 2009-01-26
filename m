From: akpm@linux-foundation.org
Subject: [merged] regulator-minor-cleanup-of-virtual-consumer-fix.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:37 -0800
Message-ID: <200901261904.n0QJ4bZE030171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZAZTHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, lrg@slimlogic.co.uk, mm-commits@vger.kernel.org


The patch titled
     regulator-minor-cleanup-of-virtual-consumer-fix
has been removed from the -mm tree.  Its filename was
     regulator-minor-cleanup-of-virtual-consumer-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator-minor-cleanup-of-virtual-consumer-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/virtual.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer-fix drivers/regulator/virtual.c
--- a/drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer-fix
+++ a/drivers/regulator/virtual.c
@@ -226,6 +226,10 @@ static ssize_t set_mode(struct device *d
 	unsigned int mode;
 	int ret;
 
+	/*
+	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
+	 * will be shared with show_mode(), above.
+	 */
 	if (sysfs_streq(buf, "fast\n") == 0)
 		mode = REGULATOR_MODE_FAST;
 	else if (sysfs_streq(buf, "normal\n") == 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
fix-x86-optimise-x86s-do_page_fault-c-entry-point-for-the-page-fault-path.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

