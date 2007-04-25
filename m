From: akpm@linux-foundation.org
Subject: - maintainers-use-listslinux-foundationorg.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:39 -0700
Message-ID: <200704252038.l3PKcd2H012240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993120AbXDYUjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: use lists.linux-foundation.org
has been removed from the -mm tree.  Its filename was
     maintainers-use-listslinux-foundationorg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: use lists.linux-foundation.org
From: David Brownell <david-b@pacbell.net>

Update various mailing list addresses to use "lists.linux-foundation.org"
instead of "lists.osdl.org", to help phase out the old addresses.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-use-listslinux-foundationorg MAINTAINERS
--- a/MAINTAINERS~maintainers-use-listslinux-foundationorg
+++ a/MAINTAINERS
@@ -1318,7 +1318,7 @@ S:	Maintained
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	bridge@lists.osdl.org
+L:	bridge@lists.linux-foundation.org
 W:	http://bridge.sourceforge.net/
 S:	Maintained
 
@@ -1951,7 +1951,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -1978,7 +1978,7 @@ S:	Maintained 
 
 KERNEL JANITORS
 P:	Several
-L:	kernel-janitors@lists.osdl.org
+L:	kernel-janitors@lists.linux-foundation.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
@@ -2001,7 +2001,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 S:	Maintained
 
 KPROBES
@@ -2339,7 +2339,7 @@ S:	Maintained
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	netem@lists.osdl.org
+L:	netem@lists.linux-foundation.org
 S:	Maintained
 
 NETFILTER/IPTABLES/IPCHAINS
@@ -3068,7 +3068,7 @@ S:	Supported
 SOFTWARE SUSPEND:
 P:	Pavel Machek
 M:	pavel@suse.cz
-L:	linux-pm@lists.osdl.org
+L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
 
 SONIC NETWORK DRIVER
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
make-proc-acpi-wakeup-more-useful.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
