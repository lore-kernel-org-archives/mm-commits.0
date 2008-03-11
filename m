From: akpm@linux-foundation.org
Subject: - i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:30 -0700
Message-ID: <200803110322.m2B3MUDU019819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYCKDWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     i8042: use SGI_HAS_I8042 to select SGI i8042 handlinig
has been removed from the -mm tree.  Its filename was
     i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8042: use SGI_HAS_I8042 to select SGI i8042 handlinig
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

origin.patch

