From: akpm@linux-foundation.org
Subject: + ipg-missing-kconfig-dependency.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:23:27 -0700
Message-ID: <200710240623.l9O6NReL026258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbXJXGXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, jesse@icplus.com.tw, sorbica@icplus.com.tw


The patch titled
     ipg: missing Kconfig dependency
has been added to the -mm tree.  Its filename is
     ipg-missing-kconfig-dependency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipg: missing Kconfig dependency
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jesse Huang <jesse@icplus.com.tw>
Cc: Sorbica Shieh <sorbica@icplus.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~ipg-missing-kconfig-dependency drivers/net/Kconfig
--- a/drivers/net/Kconfig~ipg-missing-kconfig-dependency
+++ a/drivers/net/Kconfig
@@ -168,6 +168,7 @@ config NET_SB1000
 config IP1000
        tristate "IP1000 Gigabit Ethernet support"
        depends on PCI && EXPERIMENTAL
+	select MII
        ---help---
          This driver supports IP1000 gigabit Ethernet cards.
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
ipg-missing-kconfig-dependency.patch
git-r8169.patch
