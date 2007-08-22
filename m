From: akpm@linux-foundation.org
Subject: + move-a-few-definitions-to-au1000_xxs1500c-fix.patch added to -mm tree
Date: Wed, 22 Aug 2007 11:27:19 -0700
Message-ID: <200708221827.l7MIRJIm030413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758565AbXHVS1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 14:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, linux@dominikbrodowski.net, ralf@linux-mips.org, yoichi_yuasa@tripeaks.co.jp


The patch titled
     move-a-few-definitions-to-au1000_xxs1500c fix
has been added to the -mm tree.  Its filename is
     move-a-few-definitions-to-au1000_xxs1500c-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move-a-few-definitions-to-au1000_xxs1500c fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix unbalanced parenthesis introduced by:

move-a-few-definitions-to-au1000_xxs1500c.patch

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/au1000_xxs1500.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/au1000_xxs1500.c~move-a-few-definitions-to-au1000_xxs1500c-fix drivers/pcmcia/au1000_xxs1500.c
--- a/drivers/pcmcia/au1000_xxs1500.c~move-a-few-definitions-to-au1000_xxs1500c-fix
+++ a/drivers/pcmcia/au1000_xxs1500.c
@@ -52,7 +52,7 @@
 #include <asm/au1000_pcmcia.h>
 
 #define PCMCIA_MAX_SOCK		0
-#define PCMCIA_NUM_SOCKS	PCMCIA_MAX_SOCK + 1)
+#define PCMCIA_NUM_SOCKS	(PCMCIA_MAX_SOCK + 1)
 #define PCMCIA_IRQ		AU1000_GPIO_4
 
 #if 0
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
