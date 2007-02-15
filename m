From: akpm@linux-foundation.org
Subject: + atl1-bump-version-number.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:48:42 -0800
Message-ID: <200702150548.l1F5mggJ021255@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXBOFso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: bump version number
has been added to the -mm tree.  Its filename is
     atl1-bump-version-number.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: bump version number
From: Jay Cliburn <jacliburn@bellsouth.net>

Bump the version number.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-bump-version-number drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-bump-version-number
+++ a/drivers/net/atl1/atl1_main.c
@@ -82,7 +82,7 @@
 
 #include "atl1.h"
 
-#define DRIVER_VERSION "2.0.6"
+#define DRIVER_VERSION "2.0.7"
 
 char atl1_driver_name[] = "atl1";
 static const char atl1_driver_string[] = "Attansic L1 Ethernet Network Driver";
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-drop-net_pci-from-kconfig.patch
atl1-read-mac-address-from-register.patch
atl1-remove-unused-define.patch
atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
atl1-bump-version-number.patch
