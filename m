From: akpm@linux-foundation.org
Subject: - spelling-fix-weired-weird.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:01 -0700
Message-ID: <200710180700.l9I7014U031041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761054AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Spelling fix: weired -> weird
has been removed from the -mm tree.  Its filename was
     spelling-fix-weired-weird.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spelling fix: weired -> weird
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ibmmca.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/scsi/ibmmca.txt~spelling-fix-weired-weird Documentation/scsi/ibmmca.txt
--- a/Documentation/scsi/ibmmca.txt~spelling-fix-weired-weird
+++ a/Documentation/scsi/ibmmca.txt
@@ -1188,7 +1188,7 @@
 	and 15 get ignored by the driver & adapter!
      Q: I have a 9595 and I get a NMI during heavy SCSI I/O e.g. during fsck.
         A COMMAND ERROR is reported and characters on the screen are missing.
-	Warm reboot is not possible. Things look like quite weired.
+	Warm reboot is not possible. Things look like quite weird.
      A: Check the processor type of your 9595. If you have an 80486 or 486DX-2
         processor complex on your mainboard and you compiled a kernel that
 	supports 80386 processors, it is possible, that the kernel cannot
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
netport_conc-fix-build-errors-and-warnings.patch
au1100fb-fix-modpost-warnings.patch
logoc-get-rid-of-mips_machgroup.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
