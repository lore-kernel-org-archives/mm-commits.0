From: akpm@linux-foundation.org
Subject: + input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:20:14 -0800
Message-ID: <200901302120.n0ULKFPg021889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbZA3VU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dtor@mail.ru, rydberg@euromail.se


The patch titled
     input-bcm5974-declare-alignment-usage-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch

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
Subject: input-bcm5974-declare-alignment-usage-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#45: FILE: drivers/input/mouse/bcm5974.c:137:
+} __attribute__((packed,aligned(2)));
                        ^

total: 1 errors, 0 warnings, 37 lines checked

./patches/input-bcm5974-declare-alignment-usage.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-declare-alignment-usage-checkpatch-fixes drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-declare-alignment-usage-checkpatch-fixes
+++ a/drivers/input/mouse/bcm5974.c
@@ -134,7 +134,7 @@ struct tp_finger {
 	__le16 force_minor;	/* trackpad force, minor axis? */
 	__le16 unused[3];	/* zeros */
 	__le16 multi;		/* one finger: varies, more fingers: constant */
-} __attribute__((packed,aligned(2)));
+} __attribute__((packed, aligned(2)));
 
 /* trackpad finger data size, empirically at least ten fingers */
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
drivers-ata-sata_silc-needs-dmih.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
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

