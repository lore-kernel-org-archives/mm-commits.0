From: akpm@linux-foundation.org
Subject: + pnp-fix-kernel-doc-warnings.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:05:28 -0700
Message-ID: <200707290705.l6T75Sua012886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759709AbXG2HGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     pnp: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     pnp-fix-kernel-doc-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pnp: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix PNP docbook warnings:

Warning(linux-2623-rc1g4//drivers/pnp/core.c): no structured comments found
Warning(linux-2623-rc1g4//drivers/pnp/driver.c): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~pnp-fix-kernel-doc-warnings Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~pnp-fix-kernel-doc-warnings
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -398,12 +398,12 @@ X!Edrivers/acpi/pci_bind.c
 -->
      </sect1>
      <sect1><title>Device drivers PnP support</title>
-!Edrivers/pnp/core.c
+!Idrivers/pnp/core.c
 <!-- No correct structured comments
 X!Edrivers/pnp/system.c
  -->
 !Edrivers/pnp/card.c
-!Edrivers/pnp/driver.c
+!Idrivers/pnp/driver.c
 !Edrivers/pnp/manager.c
 !Edrivers/pnp/support.c
      </sect1>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
pnp-fix-kernel-doc-warnings.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
