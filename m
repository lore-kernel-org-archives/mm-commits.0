From: akpm@linux-foundation.org
Subject: - add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:34:15 -0700
Message-ID: <200710190434.l9J4YFtq015355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966748AbXJSEeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Add extended crashkernel syntax to kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch

This patch was dropped because it was folded into add-documentation-for-extended-crashkernel-syntax.patch

------------------------------------------------------
Subject: Add extended crashkernel syntax to kernel-parameters.txt
From: Bernhard Walle <bwalle@suse.de>

This adds the documentation for the extended crashkernel syntax into
Documentation/kernel-parameters.txt.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -497,6 +497,13 @@ and is between 256 and 4096 characters. 
 			[KNL] Reserve a chunk of physical memory to
 			hold a kernel to switch to with kexec on panic.
 
+	crashkernel=range1:size1[,range2:size2,...][@offset]
+			[KNL] Same as above, but depends on the memory
+			in the running system. The syntax of range is
+			start-[end] where start and end are both
+			a memory unit (amount[KMG]). See also
+			Documentation/kdump/kdump.txt for a example.
+
 	cs4232=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
