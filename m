From: akpm@linux-foundation.org
Subject: + add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch added to -mm tree
Date: Mon, 24 Sep 2007 14:11:51 -0700
Message-ID: <200709242111.l8OLBp4Z017918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbXIXVL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Add extended crashkernel syntax to kernel-parameters.txt
has been added to the -mm tree.  Its filename is
     add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add extended crashkernel syntax to kernel-parameters.txt
From: Bernhard Walle <bwalle@suse.de>

This adds the documentation for the extended crashkernel syntax into
Documentation/kernel-parameters.txt.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -495,6 +495,13 @@ and is between 256 and 4096 characters. 
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

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
