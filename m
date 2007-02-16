From: akpm@linux-foundation.org
Subject: - before-x86_64-mm-mmconfig-share.patch removed from -mm tree
Date: Thu, 15 Feb 2007 23:54:59 -0800
Message-ID: <200702160754.l1G7sxqi023778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966176AbXBPHzB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:55:01 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1G7sxhB014538
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2007 23:55:00 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     before-x86_64-mm-mmconfig-share
has been removed from the -mm tree.  Its filename was
     before-x86_64-mm-mmconfig-share.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: before-x86_64-mm-mmconfig-share
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/pci/mmconfig.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86_64/pci/mmconfig.c~before-x86_64-mm-mmconfig-share arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~before-x86_64-mm-mmconfig-share
+++ a/arch/x86_64/pci/mmconfig.c
@@ -170,9 +170,7 @@ void __init pci_mmcfg_init(int type)
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	if (acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg))
-		return;
-
+	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
 	    (pci_mmcfg_config[0].address == 0))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
git-powerpc.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
git-input.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
