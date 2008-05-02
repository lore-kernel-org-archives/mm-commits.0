From: akpm@linux-foundation.org
Subject: - make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 02 May 2008 13:28:49 -0700
Message-ID: <200805022028.m42KSoJ5012991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764663AbYEBU25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 16:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbeulich@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following struct go on the same line
#49: FILE: kernel/module.c:995:
+struct module_sect_attr
+{

ERROR: open brace '{' following struct go on the same line
#56: FILE: kernel/module.c:1002:
+struct module_sect_attrs
+{

total: 2 errors, 0 warnings, 51 lines checked

./patches/make-module_sect_attrs-private-to-kernel-modulec.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Jan Beulich" <jbeulich@novell.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/module.c~make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes kernel/module.c
--- a/kernel/module.c~make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes
+++ a/kernel/module.c
@@ -997,15 +997,13 @@ static unsigned long resolve_symbol(Elf_
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
-struct module_sect_attr
-{
+struct module_sect_attr {
 	struct module_attribute mattr;
 	char *name;
 	unsigned long address;
 };
 
-struct module_sect_attrs
-{
+struct module_sect_attrs {
 	struct attribute_group grp;
 	unsigned int nsections;
 	struct module_sect_attr attrs[0];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
sxc-fix-printk-warnings-on-sparc32.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
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

