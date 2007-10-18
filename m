From: akpm@linux-foundation.org
Subject: - add-a-00-index-file-to-documentation-sysctl.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:21 -0700
Message-ID: <200710180704.l9I74LrW031544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761422AbXJRH1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Add a 00-INDEX file to Documentation/sysctl/
has been removed from the -mm tree.  Its filename was
     add-a-00-index-file-to-documentation-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a 00-INDEX file to Documentation/sysctl/
From: Jesper Juhl <jesper.juhl@gmail.com>

Add a 00-INDEX file to Documentation/sysctl/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN /dev/null Documentation/sysctl/00-INDEX
--- /dev/null
+++ a/Documentation/sysctl/00-INDEX
@@ -0,0 +1,16 @@
+00-INDEX
+	- this file.
+README
+	- general information about /proc/sys/ sysctl files.
+abi.txt
+	- documentation for /proc/sys/abi/*.
+ctl_unnumbered.txt
+	- explanation of why one should not add new binary sysctl numbers.
+fs.txt
+	- documentation for /proc/sys/fs/*.
+kernel.txt
+	- documentation for /proc/sys/kernel/*.
+sunrpc.txt
+	- documentation for /proc/sys/sunrpc/*.
+vm.txt
+	- documentation for /proc/sys/vm/*.
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
