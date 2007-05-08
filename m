From: akpm@linux-foundation.org
Subject: + fix-linuxdoc-comment.patch added to -mm tree
Date: Tue, 08 May 2007 14:36:39 -0700
Message-ID: <200705082136.l48Lad5D002375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032401AbXEHVgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     Fix Linuxdoc comment
has been added to the -mm tree.  Its filename is
     fix-linuxdoc-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix Linuxdoc comment
From: Jeff Dike <jdike@addtoit.com>

A linuxdoc comment had fallen out of date - it refers to an argument which no
longer exists.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/handle.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN kernel/irq/handle.c~fix-linuxdoc-comment kernel/irq/handle.c
--- a/kernel/irq/handle.c~fix-linuxdoc-comment
+++ a/kernel/irq/handle.c
@@ -22,7 +22,6 @@
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
  * @desc:      description of the interrupt
- * @regs:      pointer to a register structure
  *
  * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
  */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
