From: akpm@linux-foundation.org
Subject: - do-not-select-macintosh-drivers-by-default.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:06 -0700
Message-ID: <200706231928.l5NJS6R5022114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbXFWTeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Do not select macintosh drivers by default
has been removed from the -mm tree.  Its filename was
     do-not-select-macintosh-drivers-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Do not select macintosh drivers by default
From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/Kconfig~do-not-select-macintosh-drivers-by-default drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig~do-not-select-macintosh-drivers-by-default
+++ a/drivers/macintosh/Kconfig
@@ -2,7 +2,7 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
+	default y if PPC || MAC
 
 if MACINTOSH_DRIVERS
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are
