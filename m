From: akpm@linux-foundation.org
Subject: + ipg-kconfig-whitepaces-tab-damages.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:23:48 -0700
Message-ID: <200710240623.l9O6NmT5026261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbXJXGYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, jesse@icplus.com.tw, sorbica@icplus.com.tw


The patch titled
     ipg: Kconfig whitepaces/tab damages
has been added to the -mm tree.  Its filename is
     ipg-kconfig-whitepaces-tab-damages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipg: Kconfig whitepaces/tab damages
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jesse Huang <jesse@icplus.com.tw>
Cc: Sorbica Shieh <sorbica@icplus.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/Kconfig~ipg-kconfig-whitepaces-tab-damages drivers/net/Kconfig
--- a/drivers/net/Kconfig~ipg-kconfig-whitepaces-tab-damages
+++ a/drivers/net/Kconfig
@@ -166,14 +166,14 @@ config NET_SB1000
 	  If you don't have this card, of course say N.
 
 config IP1000
-       tristate "IP1000 Gigabit Ethernet support"
-       depends on PCI && EXPERIMENTAL
+	tristate "IP1000 Gigabit Ethernet support"
+	depends on PCI && EXPERIMENTAL
 	select MII
-       ---help---
-         This driver supports IP1000 gigabit Ethernet cards.
+	---help---
+	  This driver supports IP1000 gigabit Ethernet cards.
 
-         To compile this driver as a module, choose M here: the module
-         will be called ipg.  This is recommended.
+	  To compile this driver as a module, choose M here: the module
+	  will be called ipg.  This is recommended.
 
 source "drivers/net/arcnet/Kconfig"
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
ipg-missing-kconfig-dependency.patch
ipg-kconfig-whitepaces-tab-damages.patch
git-r8169.patch
