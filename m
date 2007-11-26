From: akpm@linux-foundation.org
Subject: + m68k-zorro7xx-needs-asm-amigahwh.patch added to -mm tree
Date: Mon, 26 Nov 2007 00:16:39 -0800
Message-ID: <200711260816.lAQ8GdPD023879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbXKZIRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, ij@2007.bluespice.org


The patch titled
     m68k: zorro7xx needs <asm/amigahw.h>
has been added to the -mm tree.  Its filename is
     m68k-zorro7xx-needs-asm-amigahwh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: zorro7xx needs <asm/amigahw.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: zorro7xx needs <asm/amigahw.h> if !CONFIG_AMIGA_PCMCIA

Reported by Ingo Juergensmann <ij@2007.bluespice.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/zorro7xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/zorro7xx.c~m68k-zorro7xx-needs-asm-amigahwh drivers/scsi/zorro7xx.c
--- a/drivers/scsi/zorro7xx.c~m68k-zorro7xx-needs-asm-amigahwh
+++ a/drivers/scsi/zorro7xx.c
@@ -13,7 +13,10 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/zorro.h>
+
+#include <asm/amigahw.h>
 #include <asm/amigaints.h>
+
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_spi.h>
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-export-atari_keyb_init.patch
amiga-zorro-bus-add-missing-zorro_device_remove.patch
mac68k-mailing-list-addresss.patch
m68k-zorro7xx-needs-asm-amigahwh.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
add-cmpxchg_local-to-m86k.patch
