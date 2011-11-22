From: akpm@linux-foundation.org
Subject: + mips-randomize-pie-load-address.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:26:07 -0800
Message-ID: <201111222326.pAMNQ8NQ006442@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:34376 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KVX0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:26:12 -0500
Received: by wwe5 with SMTP id 5so28693wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:26:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney.cavm@gmail.com, david.daney@cavium.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: MIPS: randomize PIE load address
has been added to the -mm tree.  Its filename is
     mips-randomize-pie-load-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <ddaney.cavm@gmail.com>
Subject: MIPS: randomize PIE load address

... by selecting ARCH_BINFMT_ELF_RANDOMIZE_PIE

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/Kconfig~mips-randomize-pie-load-address arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-randomize-pie-load-address
+++ a/arch/mips/Kconfig
@@ -25,6 +25,7 @@ config MIPS
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 
 menu "Machine selection"
 
_
Subject: Subject: MIPS: randomize PIE load address

Patches currently in -mm which might be from ddaney.cavm@gmail.com are

linux-next.patch
fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch
mips-randomize-pie-load-address.patch

