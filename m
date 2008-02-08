From: akpm@linux-foundation.org
Subject: + pata_amd-note-in-the-module-description-it-handles-nvidia.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:38:12 -0800
Message-ID: <200802082138.m18LcCRJ014601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbYBHVlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_amd: note in the module description it handles Nvidia
has been added to the -mm tree.  Its filename is
     pata_amd-note-in-the-module-description-it-handles-nvidia.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x25_asy-fix-ref-count-rule-violation.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-note-in-the-module-description-it-handles-nvidia.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
megaraid-outb_p-extermination.patch
git-watchdog.patch
tty-bkl-pushdown.patch
