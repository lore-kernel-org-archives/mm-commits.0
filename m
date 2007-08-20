From: akpm@linux-foundation.org
Subject: - drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:09 -0700
Message-ID: <200708201913.l7KJD9Gp018412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756297AbXHTTVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/g_NCR5380.c: "NCR53C400_PSEUDO_DMA" is not  defined
has been removed from the -mm tree.  Its filename was
     drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/g_NCR5380.c: "NCR53C400_PSEUDO_DMA" is not  defined
From: Gabriel C <nix.or.die@googlemail.com>

Got this warning with current git:

...

In file included from drivers/scsi/g_NCR5380_mmio.c:9:
drivers/scsi/g_NCR5380.c:559:5: warning: "NCR53C400_PSEUDO_DMA" is not defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/g_NCR5380.c~drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not
+++ a/drivers/scsi/g_NCR5380.c
@@ -556,7 +556,7 @@ generic_NCR5380_biosparam(struct scsi_de
 }
 #endif
 
-#if NCR53C400_PSEUDO_DMA
+#ifdef NCR53C400_PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

git-powerpc.patch
git-kvm.patch
git-scsi-misc.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
