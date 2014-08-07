From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-signed-generic-types.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:09:29 -0700
Message-ID: <53e3dcf9.ZCTWpzv79Hm4k1eh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:39778 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaHGUJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:30 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so880158igd.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add signed generic types
has been removed from the -mm tree.  Its filename was
     checkpatch-add-signed-generic-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add signed generic types

Current generic types are unsigned or unspecified.
Add signed to the types.

Reorder the types to find the longest match first.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-signed-generic-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-signed-generic-types
+++ a/scripts/checkpatch.pl
@@ -355,15 +355,15 @@ our $signature_tags = qr{(?xi:
 
 our @typeList = (
 	qr{void},
-	qr{(?:unsigned\s+)?char},
-	qr{(?:unsigned\s+)?short\s+int},
-	qr{(?:unsigned\s+)?short},
-	qr{(?:unsigned\s+)?int},
-	qr{(?:unsigned\s+)?long},
-	qr{(?:unsigned\s+)?long\s+int},
-	qr{(?:unsigned\s+)?long\s+long},
-	qr{(?:unsigned\s+)?long\s+long\s+int},
-	qr{unsigned},
+	qr{(?:(?:un)?signed\s+)?char},
+	qr{(?:(?:un)?signed\s+)?short\s+int},
+	qr{(?:(?:un)?signed\s+)?short},
+	qr{(?:(?:un)?signed\s+)?int},
+	qr{(?:(?:un)?signed\s+)?long\s+int},
+	qr{(?:(?:un)?signed\s+)?long\s+long\s+int},
+	qr{(?:(?:un)?signed\s+)?long\s+long},
+	qr{(?:(?:un)?signed\s+)?long},
+	qr{(?:un)?signed},
 	qr{float},
 	qr{double},
 	qr{bool},
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
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
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

