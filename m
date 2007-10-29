From: akpm@linux-foundation.org
Subject: - ipg-missing-kconfig-dependency.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:05 -0700
Message-ID: <200710292031.l9TKV5Ev021825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbXJ2UbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, jesse@icplus.com.tw, sorbica@icplus.com.tw, mm-commits@vger.kernel.org


The patch titled
     ipg: missing Kconfig dependency
has been removed from the -mm tree.  Its filename was
     ipg-missing-kconfig-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
