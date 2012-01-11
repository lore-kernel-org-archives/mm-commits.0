From: akpm@linux-foundation.org
Subject: [merged] mips-randomize-pie-load-address.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:53 -0800
Message-ID: <20120111213153.B372A1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:54 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney.cavm@gmail.com, david.daney@cavium.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: randomize PIE load address
has been removed from the -mm tree.  Its filename was
     mips-randomize-pie-load-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -16,6 +16,7 @@ config MIPS
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_DMA_ATTRS
_

Patches currently in -mm which might be from ddaney.cavm@gmail.com are

origin.patch
linux-next.patch

