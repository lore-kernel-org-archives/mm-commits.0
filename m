From: akpm@linux-foundation.org
Subject: - drivers-macintosh-remove-default-y-from-kconfig-was-re-2621-mm1.patch removed from -mm tree
Date: Tue, 08 May 2007 15:55:06 -0700
Message-ID: <200705082255.l48Mt6jv004118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968521AbXEHWzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 18:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     drivers/macintosh: remove default y from Kconfig
has been removed from the -mm tree.  Its filename was
     drivers-macintosh-remove-default-y-from-kconfig-was-re-2621-mm1.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: drivers/macintosh: remove default y from Kconfig
From: Borislav Petkov <bbpetkov@yahoo.de>

Do not select macintosh drivers by default.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/macintosh/Kconfig~drivers-macintosh-remove-default-y-from-kconfig-was-re-2621-mm1 drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig~drivers-macintosh-remove-default-y-from-kconfig-was-re-2621-mm1
+++ a/drivers/macintosh/Kconfig
@@ -2,7 +2,6 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
 
 if MACINTOSH_DRIVERS
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
kill-warnings-when-building-mandocs.patch
drivers-macintosh-remove-default-y-from-kconfig-was-re-2621-mm1.patch
kernel-doc-small-kernel-doc-optimization.patch
