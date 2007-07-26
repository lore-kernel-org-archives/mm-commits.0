From: akpm@linux-foundation.org
Subject: + drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:45:34 -0700
Message-ID: <200707262045.l6QKjYKr020053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbXGZUpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com


The patch titled
     drivers/scsi/g_NCR5380.c: "NCR53C400_PSEUDO_DMA" is not  defined
has been added to the -mm tree.  Its filename is
     drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
broken-lilo-check-on-make-install.patch
typo-fixes-errror-error.patch
