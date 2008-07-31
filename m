From: akpm@linux-foundation.org
Subject: - drivers-telephony-ixjc-depends-on-pnp.patch removed from -mm tree
Date: Thu, 31 Jul 2008 02:10:56 -0700
Message-ID: <200807310911.m6V9AuVp014469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYGaJLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 05:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, toralf.foerster@gmx.de, mm-commits@vger.kernel.org


The patch titled
     drivers/telephony/ixj.c depends on PNP
has been removed from the -mm tree.  Its filename was
     drivers-telephony-ixjc-depends-on-pnp.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/telephony/ixj.c depends on PNP
=46rom: Andrew Morton <akpm@linux-foundation.org>

drivers/built-in.o: In function `pnp_port_start':
/home/tfoerste/devel/linux-2.6/include/linux/pnp.h:51: undefined refere=
nce to `pnp_get_resource'

Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/telephony/Kconfig~drivers-telephony-ixjc-depends-on-p=
np drivers/telephony/Kconfig
--- a/drivers/telephony/Kconfig~drivers-telephony-ixjc-depends-on-pnp
+++ a/drivers/telephony/Kconfig
@@ -20,6 +20,7 @@ if PHONE
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
 	depends on ISA || PCI
+	depends on PNP
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
missing-symbol-prefix-on-vmlinuxldsh.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
next-remove-localversion.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
x86-export-is_uv_system.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh=
=2Epatch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=3Dn.patch
usb-hubc-fix-build-with-config_pm=3Dn.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff=
=2Epatch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
