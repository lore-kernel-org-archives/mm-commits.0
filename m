From: akpm@linux-foundation.org
Subject: - drivers-input-mouse-kconfig-fix-typo.patch removed from -mm tree
Date: Tue, 05 Jun 2007 00:10:30 -0700
Message-ID: <200706050710.l557ASMq031271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763319AbXFEHKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 03:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uwe.bugla@gmx.de, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/mouse/Kconfig: fix typo
has been removed from the -mm tree.  Its filename was
     drivers-input-mouse-kconfig-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
