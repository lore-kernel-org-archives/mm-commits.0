From: akpm@linux-foundation.org
Subject: + frv-remove-dead-config-symbol-from-frv-code.patch added to -mm tree
Date: Thu, 08 Nov 2007 10:10:56 -0800
Message-ID: <200711081810.lA8IAuaW007622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761064AbXKHSLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 13:11:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, dhowells@redhat.com


The patch titled
     frv: remove dead config symbol from FRV code
has been added to the -mm tree.  Its filename is
     frv-remove-dead-config-symbol-from-frv-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: frv: remove dead config symbol from FRV code
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbol from FRV code.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/page.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/asm-frv/page.h~frv-remove-dead-config-symbol-from-frv-code include/asm-frv/page.h
--- a/include/asm-frv/page.h~frv-remove-dead-config-symbol-from-frv-code
+++ a/include/asm-frv/page.h
@@ -76,10 +76,6 @@ extern unsigned long max_pfn;
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
-#define WANT_PAGE_VIRTUAL	1
-#endif
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
_

Patches currently in -mm which might be from olsajiri@gmail.com are

drivers-serial-s3c2410c-remove-dead-config-symbols.patch
sh-remove-dead-config-symbol-from-sh-code.patch
frv-remove-dead-config-symbol-from-frv-code.patch
blackfin-remove-dead-config-symbol-from-blackfin-code.patch
