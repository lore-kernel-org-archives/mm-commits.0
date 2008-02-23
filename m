From: akpm@linux-foundation.org
Subject: + i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:28 -0800
Message-ID: <200802230733.m1N7XHnj018205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbYBWHyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, dtor@mail.ru


The patch titled
     I8042: Use SGI_HAS_I8042 to select SGI i8042 handlinig
has been added to the -mm tree.  Its filename is
     i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: I8042: Use SGI_HAS_I8042 to select SGI i8042 handlinig
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use SGI_HAS_I8042 to select SGI i8042 handling

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/serio/i8042.h~i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig drivers/input/serio/i8042.h
--- a/drivers/input/serio/i8042.h~i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig
+++ a/drivers/input/serio/i8042.h
@@ -16,7 +16,7 @@
 
 #if defined(CONFIG_MACH_JAZZ)
 #include "i8042-jazzio.h"
-#elif defined(CONFIG_SGI_IP22)
+#elif defined(CONFIG_SGI_HAS_I8042)
 #include "i8042-ip22io.h"
 #elif defined(CONFIG_PPC)
 #include "i8042-ppcio.h"
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

mips-fix-sni_rm-eisa=n-compilation.patch
git-watchdog.patch
i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch
