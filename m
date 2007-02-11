From: akpm@linux-foundation.org
Subject: - git-scsi-misc-fixup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:56:09 -0800
Message-ID: <200702112256.l1BMu9b1016386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896AbXBKW4K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:10 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1BMu9UI016790
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 11 Feb 2007 14:56:09 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-scsi-misc-fixup
has been removed from the -mm tree.  Its filename was
     git-scsi-misc-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-scsi-misc-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/scsi/ipr.c~git-scsi-misc-fixup drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~git-scsi-misc-fixup
+++ a/drivers/scsi/ipr.c
@@ -7549,14 +7549,9 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-<<<<<<< HEAD/drivers/scsi/ipr.c
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
-=======
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0, 0 },
->>>>>>> /drivers/scsi/ipr.c
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
