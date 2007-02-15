From: akpm@linux-foundation.org
Subject: + atl1-remove-unused-define.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:48:38 -0800
Message-ID: <200702150548.l1F5mctU021248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbXBOFsw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: csnook@redhat.com, jacliburn@bellsouth.net


The patch titled
     atl1: remove unused define
has been added to the -mm tree.  Its filename is
     atl1-remove-unused-define.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: remove unused define
From: Chris Snook <csnook@redhat.com>

Remove unused define from atl1_main.c.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-remove-unused-define drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-remove-unused-define
+++ a/drivers/net/atl1/atl1_main.c
@@ -82,7 +82,6 @@
 
 #include "atl1.h"
 
-#define RUN_REALTIME 0
 #define DRIVER_VERSION "2.0.6"
 
 char atl1_driver_name[] = "atl1";
_

Patches currently in -mm which might be from csnook@redhat.com are

atl1-drop-net_pci-from-kconfig.patch
atl1-read-mac-address-from-register.patch
atl1-remove-unused-define.patch
atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
