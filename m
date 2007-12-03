From: akpm@linux-foundation.org
Subject: + char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:01:21 -0800
Message-ID: <200712032301.lB3N1LO8022010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbXLCXBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:01:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, ralf@linux-mips.org


The patch titled
     char: use SGI_HAS_DS1286 for SGI_DS1286 depends
has been added to the -mm tree.  Its filename is
     char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: char: use SGI_HAS_DS1286 for SGI_DS1286 depends
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use SGI_HAS_DS1286 for SGI_DS1286 depends

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~char-use-sgi_has_ds1286-for-sgi_ds1286-depends drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-use-sgi_has_ds1286-for-sgi_ds1286-depends
+++ a/drivers/char/Kconfig
@@ -791,7 +791,7 @@ config JS_RTC
 
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
-	depends on SGI_IP22
+	depends on SGI_HAS_DS1286
 	help
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
git-mips.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
