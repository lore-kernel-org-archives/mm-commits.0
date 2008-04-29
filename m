From: akpm@linux-foundation.org
Subject: - pcmcia-unschedule-the-planned-removal-of-the-pcmcia_ioctl-feature.patch removed from -mm tree
Date: Tue, 29 Apr 2008 15:40:06 -0700
Message-ID: <200804292240.m3TMe7dj013809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYD2Wks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 18:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     PCMCIA: unschedule the planned removal of the PCMCIA_IOCTL feature
has been removed from the -mm tree.  Its filename was
     pcmcia-unschedule-the-planned-removal-of-the-pcmcia_ioctl-feature.patch

This patch was dropped because we should at least leave it on the todo list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCMCIA: unschedule the planned removal of the PCMCIA_IOCTL feature
From: Andrew Morton <akpm@linux-foundation.org>

Russell has some machine whihc still needs this.

Cc: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~pcmcia-unschedule-the-planned-removal-of-the-pcmcia_ioctl-feature Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pcmcia-unschedule-the-planned-removal-of-the-pcmcia_ioctl-feature
+++ a/Documentation/feature-removal-schedule.txt
@@ -47,23 +47,6 @@ Who:	Mauro Carvalho Chehab <mchehab@infr
 
 ---------------------------
 
-What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
-When:	November 2005
-Files:	drivers/pcmcia/: pcmcia_ioctl.c
-Why:	With the 16-bit PCMCIA subsystem now behaving (almost) like a
-	normal hotpluggable bus, and with it using the default kernel
-	infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
-	control ioctl needed by cardmgr and cardctl from pcmcia-cs is
-	unnecessary, and makes further cleanups and integration of the
-	PCMCIA subsystem into the Linux kernel device driver model more
-	difficult. The features provided by cardmgr and cardctl are either
-	handled by the kernel itself now or are available in the new
-	pcmciautils package available at
-	http://kernel.org/pub/linux/utils/kernel/pcmcia/
-Who:	Dominik Brodowski <linux@brodo.de>
-
----------------------------
-
 What:	sys_sysctl
 When:	September 2010
 Option: CONFIG_SYSCTL_SYSCALL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroups-implement-device-whitelist-v6.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-implement-failcounter-reset.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipmi-run-to-completion-fixes.patch
ipmi-style-fixes-in-the-system-interface-code.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
ncpfs-use-get-put_unaligned_-helpers.patch
relayfs-support-larger-relay-buffer-take-3.patch
pcmcia-unschedule-the-planned-removal-of-the-pcmcia_ioctl-feature.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
x86-ptrace-pebs-support-warning-fix.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
drivers-media-dvb-frontends-s5h1420c-printk-fix.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

