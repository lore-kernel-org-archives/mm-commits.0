From: akpm@linux-foundation.org
Subject: + drivers-input-mouse-kconfig-fix-typo.patch added to -mm tree
Date: Tue, 29 May 2007 16:46:17 -0700
Message-ID: <200705292346.l4TNkHrE014594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXE2XqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uwe.bugla@gmx.de, dtor@mail.ru


The patch titled
     drivers/input/mouse/Kconfig: fix typo
has been added to the -mm tree.  Its filename is
     drivers-input-mouse-kconfig-fix-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/input/mouse/Kconfig: fix typo
From: "Uwe Bugla" <uwe.bugla@gmx.de>

Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mouse/Kconfig~drivers-input-mouse-kconfig-fix-typo drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig~drivers-input-mouse-kconfig-fix-typo
+++ a/drivers/input/mouse/Kconfig
@@ -48,7 +48,7 @@ config MOUSE_PS2_ALPS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LOGIPS2PP
-	bool "Logictech PS/2++ mouse protocol extension" if EMBEDDED
+	bool "Logitech PS/2++ mouse protocol extension" if EMBEDDED
 	default y
 	depends on MOUSE_PS2
 	help
_

Patches currently in -mm which might be from uwe.bugla@gmx.de are

git-dvb.patch
drivers-input-mouse-kconfig-fix-typo.patch
