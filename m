From: akpm@linux-foundation.org
Subject: - usb-make-usb_storage_onetouch-available-with-pm.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:59 -0800
Message-ID: <200802232022.m1NKMxAi013473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763171AbYBWU30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, gregkh@suse.de, just.for.lkml@googlemail.com, mdharm-usb@one-eyed-alien.net, n.sillik@temple.edu, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: make USB_STORAGE_ONETOUCH available with PM
has been removed from the -mm tree.  Its filename was
     usb-make-usb_storage_onetouch-available-with-pm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: make USB_STORAGE_ONETOUCH available with PM
From: Adrian Bunk <bunk@kernel.org>

As Torsten Kaiser pointed out, it seems the dependency of
USB_STORAGE_ONETOUCH on !PM should have been removed in commit
7931e1c6f8007d5fef8a0bb2dc71bd97315eeae9.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Nick Sillik <n.sillik@temple.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/storage/Kconfig~usb-make-usb_storage_onetouch-available-with-pm drivers/usb/storage/Kconfig
--- a/drivers/usb/storage/Kconfig~usb-make-usb_storage_onetouch-available-with-pm
+++ a/drivers/usb/storage/Kconfig
@@ -123,7 +123,7 @@ config USB_STORAGE_ALAUDA
 
 config USB_STORAGE_ONETOUCH
 	bool "Support OneTouch Button on Maxtor Hard Drives (EXPERIMENTAL)"
-	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL && !PM
+	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL
 	help
 	  Say Y here to include additional code to support the Maxtor OneTouch
 	  USB hard drive's onetouch button.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
