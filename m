From: akpm@linux-foundation.org
Subject: - pata_amd-note-in-the-module-description-it-handles-nvidia.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:32 -0800
Message-ID: <200802132015.m1DKFWGr011376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbYBMUQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_amd: note in the module description it handles Nvidia
has been removed from the -mm tree.  Its filename was
     pata_amd-note-in-the-module-description-it-handles-nvidia.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_amd: note in the module description it handles Nvidia
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This has confused a few people so fix it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-note-in-the-module-description-it-handles-nvidia drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-note-in-the-module-description-it-handles-nvidia
+++ a/drivers/ata/pata_amd.c
@@ -772,7 +772,7 @@ static void __exit amd_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for AMD PATA IDE");
+MODULE_DESCRIPTION("low-level driver for AMD and Nvidia PATA IDE");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, amd);
 MODULE_VERSION(DRV_VERSION);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
git-sh.patch
megaraid-outb_p-extermination.patch
git-watchdog.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
