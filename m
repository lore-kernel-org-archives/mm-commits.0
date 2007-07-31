From: akpm@linux-foundation.org
Subject: - pnp-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:28 -0700
Message-ID: <200707312355.l6VNtSMx029227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbXHAAQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     pnp: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     pnp-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
