From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysctl-remove-now-unused-typedef-ctl_table-fix.patch removed from -mm tree
Date: Fri, 08 Aug 2014 13:59:16 -0700
Message-ID: <53e53a24.XHexk+qq2kf5hECZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:56887 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaHHU7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:59:17 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1099200obb.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:59:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-remove-now-unused-typedef-ctl_table-fix
has been removed from the -mm tree.  Its filename was
     sysctl-remove-now-unused-typedef-ctl_table-fix.patch

This patch was dropped because it was folded into sysctl-remove-now-unused-typedef-ctl_table.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sysctl-remove-now-unused-typedef-ctl_table-fix

Not so fast buckwheat.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table-fix fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table-fix
+++ a/fs/proc/proc_sysctl.c
@@ -632,7 +632,7 @@ out:
 	return ret;
 }
 
-static int scan(struct ctl_table_header *head, ctl_table *table,
+static int scan(struct ctl_table_header *head, struct ctl_table *table,
 		unsigned long *pos, struct file *file,
 		struct dir_context *ctx)
 {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
maintainers-remove-two-ancient-eata-sections.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

