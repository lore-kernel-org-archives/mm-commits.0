From: akpm@linux-foundation.org
Subject: - add-missing-taint-comment.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:48 -0800
Message-ID: <200812021838.mB2Icm6h007146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150AbYLBSiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     taint: add missing comment
has been removed from the -mm tree.  Its filename was
     add-missing-taint-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taint: add missing comment
From: Arjan van de Ven <arjan@linux.intel.com>

The description for 'D' was missing in the comment...  (causing me a
minute of WTF followed by looking at more of the code)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/panic.c~add-missing-taint-comment kernel/panic.c
--- a/kernel/panic.c~add-missing-taint-comment
+++ a/kernel/panic.c
@@ -167,6 +167,7 @@ static const struct tnt tnts[] = {
  *  'M' - System experienced a machine check exception.
  *  'B' - System has hit bad_page.
  *  'U' - Userspace-defined naughtiness.
+ *  'D' - Kernel has oopsed before
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
vfs-expand-some-comments-d_path-seq_path.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
oops-increment-the-oops-uuid-every-time-we-oops.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch

