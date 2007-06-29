From: akpm@linux-foundation.org
Subject: - mips-jazz-correct-flags-for-timer-io-resource.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:00 -0700
Message-ID: <200706292041.l5TKf0Nt022544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbXF2Uuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips-jazz: correct flags for timer io resource
has been removed from the -mm tree.  Its filename was
     mips-jazz-correct-flags-for-timer-io-resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips-jazz: correct flags for timer io resource
From: Alexey Dobriyan <adobriyan@gmail.com>

arch/mips/jazz/setup.c:55:4: error: Initializer entry defined twice

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/jazz/setup.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/jazz/setup.c~mips-jazz-correct-flags-for-timer-io-resource arch/mips/jazz/setup.c
--- a/arch/mips/jazz/setup.c~mips-jazz-correct-flags-for-timer-io-resource
+++ a/arch/mips/jazz/setup.c
@@ -54,7 +54,7 @@ static struct resource jazz_io_resources
 		.start	= 0x40,
 		.end	= 0x5f,
 		.name	= "timer",
-		.end	= IORESOURCE_BUSY
+		.flags	= IORESOURCE_BUSY
 	}, {
 		.start	= 0x80,
 		.end	= 0x8f,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
