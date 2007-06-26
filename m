From: akpm@linux-foundation.org
Subject: + mips-jazz-correct-flags-for-timer-io-resource.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:30:14 -0700
Message-ID: <200706262130.l5QLUEsn002468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758343AbXFZVaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ralf@linux-mips.org


The patch titled
     mips-jazz: correct flags for timer io resource
has been added to the -mm tree.  Its filename is
     mips-jazz-correct-flags-for-timer-io-resource.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips-jazz: correct flags for timer io resource
From: Alexey Dobriyan <adobriyan@gmail.com>

arch/mips/jazz/setup.c:55:4: error: Initializer entry defined twice

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
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

mips-jazz-correct-flags-for-timer-io-resource.patch
procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
