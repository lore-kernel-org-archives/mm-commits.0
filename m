From: akpm@linux-foundation.org
Subject: - drivers-edac-add-info-kconfig.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:39 -0700
Message-ID: <200707192006.l6JK6dkd020164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469AbXGSUPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add info kconfig
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-info-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add info kconfig
From: Douglas Thompson <dougthompson@xmission.com>

Kconfig - modified the help of EDAC

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/edac/Kconfig~drivers-edac-add-info-kconfig drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~drivers-edac-add-info-kconfig
+++ a/drivers/edac/Kconfig
@@ -13,8 +13,9 @@ menuconfig EDAC
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or
-	  supporting chipset: memory errors, cache errors, PCI errors,
-	  thermal throttling, etc..  If unsure, select 'Y'.
+	  supporting chipset or other subsystems:
+	  memory errors, cache errors, PCI errors, thermal throttling, etc..
+	  If unsure, select 'Y'.
 
 	  If this code is reporting problems on your system, please
 	  see the EDAC project web pages for more information at:
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
