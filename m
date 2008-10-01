From: akpm@linux-foundation.org
Subject: - irda-follow-lspci-device-vendor-style.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:03 -0700
Message-ID: <200810012151.m91Lp3jV005897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbYJAVvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     irda: follow lspci device/vendor style
has been removed from the -mm tree.  Its filename was
     irda-follow-lspci-device-vendor-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irda: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/vlsi_ir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/vlsi_ir.c~irda-follow-lspci-device-vendor-style drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~irda-follow-lspci-device-vendor-style
+++ a/drivers/net/irda/vlsi_ir.c
@@ -165,7 +165,7 @@ static void vlsi_proc_pdev(struct seq_fi
 	unsigned iobase = pci_resource_start(pdev, 0);
 	unsigned i;
 
-	seq_printf(seq, "\n%s (vid/did: %04x/%04x)\n",
+	seq_printf(seq, "\n%s (vid/did: [%04x:%04x])\n",
 		   pci_name(pdev), (int)pdev->vendor, (int)pdev->device);
 	seq_printf(seq, "pci-power-state: %u\n", (unsigned) pdev->current_state);
 	seq_printf(seq, "resources: irq=%u / io=0x%04x / dma_mask=0x%016Lx\n",
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-pci.patch
git-v4l-dvb.patch
git-acpi.patch
git-scsi.patch
git-net.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
agp-follow-lspci-device-vendor-style.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
rtc-cmos-export-second-nvram-bank.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

