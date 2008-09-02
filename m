From: akpm@linux-foundation.org
Subject: + modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:33:55 -0700
Message-ID: <200809022333.m82NXuwZ018551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbYIBXeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@firstfloor.org, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au


The patch titled
     modules-remove-stop_machine-during-module-load-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules-remove-stop_machine-during-module-load-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#83: FILE: kernel/module.c:2258:
+         * strong_try_module_get() will fail.$

total: 1 errors, 0 warnings, 130 lines checked

./patches/modules-remove-stop_machine-during-module-load.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/module.c~modules-remove-stop_machine-during-module-load-checkpatch-fixes kernel/module.c
--- a/kernel/module.c~modules-remove-stop_machine-during-module-load-checkpatch-fixes
+++ a/kernel/module.c
@@ -2254,8 +2254,8 @@ static noinline struct module *load_modu
 		       mod->name);
 
 	/* Now sew it into the lists so we can get lockdep and oops
-         * info during argument parsing.  Noone should access us, since
-         * strong_try_module_get() will fail.
+	 * info during argument parsing.  Noone should access us, since
+	 * strong_try_module_get() will fail.
 	 * lockdep/oops can run asynchronous, so use the RCU list insertion
 	 * function to insert in a way safe to concurrent readers.
 	 * The mutex protects against concurrent writers.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch
acer-wmi-remove-debugfs-entries-upon-unloading.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-git-rejects.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

