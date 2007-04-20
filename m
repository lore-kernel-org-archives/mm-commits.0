From: akpm@linux-foundation.org
Subject: + maintainers-use-listslinux-foundationorg.patch added to -mm tree
Date: Fri, 20 Apr 2007 14:41:33 -0700
Message-ID: <200704202141.l3KLfXgc024504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767283AbXDTVlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 17:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     MAINTAINERS: use lists.linux-foundation.org
has been added to the -mm tree.  Its filename is
     maintainers-use-listslinux-foundationorg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: use lists.linux-foundation.org
From: David Brownell <david-b@pacbell.net>

Update various mailing list addresses to use "lists.linux-foundation.org"
instead of "lists.osdl.org", to help phase out the old addresses.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-use-listslinux-foundationorg MAINTAINERS
--- a/MAINTAINERS~maintainers-use-listslinux-foundationorg
+++ a/MAINTAINERS
@@ -1320,7 +1320,7 @@ S:	Maintained
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	bridge@lists.osdl.org
+L:	bridge@lists.linux-foundation.org
 W:	http://bridge.sourceforge.net/
 S:	Maintained
 
@@ -1953,7 +1953,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -1980,7 +1980,7 @@ S:	Maintained 
 
 KERNEL JANITORS
 P:	Several
-L:	kernel-janitors@lists.osdl.org
+L:	kernel-janitors@lists.linux-foundation.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
@@ -2003,7 +2003,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.osdl.org
+L:	fastboot@lists.linux-foundation.org
 S:	Maintained
 
 KPROBES
@@ -2341,7 +2341,7 @@ S:	Maintained
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	netem@lists.osdl.org
+L:	netem@lists.linux-foundation.org
 S:	Maintained
 
 NETFILTER/IPTABLES/IPCHAINS
@@ -3070,7 +3070,7 @@ S:	Supported
 SOFTWARE SUSPEND:
 P:	Pavel Machek
 M:	pavel@suse.cz
-L:	linux-pm@lists.osdl.org
+L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
 
 SONIC NETWORK DRIVER
_

Patches currently in -mm which might be from david-b@pacbell.net are

maintainers-use-listslinux-foundationorg.patch
make-proc-acpi-wakeup-more-useful.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
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
