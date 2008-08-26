From: akpm@linux-foundation.org
Subject: - drivers-misc-eeprom_93cx6c-remove-include-versionh.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:50 -0700
Message-ID: <200808261845.m7QIjoUt021436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756581AbYHZSqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/eeprom_93cx6.c: remove #include <version.h>
has been removed from the -mm tree.  Its filename was
     drivers-misc-eeprom_93cx6c-remove-include-versionh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/eeprom_93cx6.c: remove #include <version.h>
From: Huang Weiyi <weiyi.huang@gmail.com>

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom_93cx6.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/eeprom_93cx6.c~drivers-misc-eeprom_93cx6c-remove-include-versionh drivers/misc/eeprom_93cx6.c
--- a/drivers/misc/eeprom_93cx6.c~drivers-misc-eeprom_93cx6c-remove-include-versionh
+++ a/drivers/misc/eeprom_93cx6.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/eeprom_93cx6.h>
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

