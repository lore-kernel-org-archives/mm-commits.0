From: akpm@linux-foundation.org
Subject: + add-missing-taint-comment.patch added to -mm tree
Date: Tue, 25 Nov 2008 16:11:28 -0800
Message-ID: <200811260011.mAQ0BSve002484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYKZALb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 19:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     From: Arjan van de Ven <arjan@linux.intel.com>
has been added to the -mm tree.  Its filename is
     add-missing-taint-comment.patch

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
Subject: From: Arjan van de Ven <arjan@linux.intel.com>
From: Arjan van de Ven <arjan@linux.intel.com>

From c89de9be4c5e775bb1dd5a3aea393eccd4524eb3 Mon Sep 17 00:00:00 2001
Date: Tue, 25 Nov 2008 08:18:49 -0800
Subject: [PATCH] Add missing taint comment

the description for 'D' was missing in the comment...
(causing me a minute of WTF followed by looking at more of the code)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---

index b01f578..d1ac662 100644
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

add-missing-taint-comment.patch
linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
resource-allow-mmio-exclusivity-for-device-drivers.patch
vfs-expand-some-comments-d_path-seq_path.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
oops-increment-the-oops-uuid-every-time-we-oops.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch

