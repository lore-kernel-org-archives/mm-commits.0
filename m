From: akpm@linux-foundation.org
Subject: - add-a-00-index-file-to-documentation-mips.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:19 -0700
Message-ID: <200710180704.l9I74JLY031541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbXJRHhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, ralf@linux-mips.org, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Add a 00-INDEX file to Documentation/mips/
has been removed from the -mm tree.  Its filename was
     add-a-00-index-file-to-documentation-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a 00-INDEX file to Documentation/mips/
From: Jesper Juhl <jesper.juhl@gmail.com>

Add a 00-INDEX file to Documentation/mips/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mips/00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN /dev/null Documentation/mips/00-INDEX
--- /dev/null
+++ a/Documentation/mips/00-INDEX
@@ -0,0 +1,8 @@
+00-INDEX
+	- this file.
+AU1xxx_IDE.README
+	- README for MIPS AU1XXX IDE driver.
+GT64120.README
+	- README for dir with info on MIPS boards using GT-64120 or GT-64120A.
+time.README
+	- README for MIPS time services.
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
