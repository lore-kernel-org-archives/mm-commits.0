From: akpm@linux-foundation.org
Subject: - apm-fix-incorrect-comment.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:06 -0700
Message-ID: <200705090250.l492o6PY009310@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969951AbXEICuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     apm: fix incorrect comment
has been removed from the -mm tree.  Its filename was
     apm-fix-incorrect-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: apm: fix incorrect comment
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

HZ has not always been 100Hz for some time.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/apm.c~apm-fix-incorrect-comment arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~apm-fix-incorrect-comment
+++ a/arch/i386/kernel/apm.c
@@ -1172,7 +1172,7 @@ static void reinit_timer(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-	/* set the clock to 100 Hz */
+	/* set the clock to HZ */
 	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
 	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-pata_qdic-probe-code.patch
pata_scc-fix-compilation.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
upper-32-bits.patch
tty_set_ldisc-receive_room-fix.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
