From: akpm@linux-foundation.org
Subject: - m68k-zorro7xx-needs-asm-amigahwh.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:34 -0800
Message-ID: <200712010021.lB10LYN6031770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491AbXLAAWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ij@2007.bluespice.org, mm-commits@vger.kernel.org


The patch titled
     m68k: zorro7xx needs <asm/amigahw.h>
has been removed from the -mm tree.  Its filename was
     m68k-zorro7xx-needs-asm-amigahwh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
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
