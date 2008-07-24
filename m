From: akpm@linux-foundation.org
Subject: - tdfxfb-add-mode_option-module-parameter.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:09 -0700
Message-ID: <200807242332.m6ONW99C011803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348AbYGXXcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: add mode_option module parameter
has been removed from the -mm tree.  Its filename was
     tdfxfb-add-mode_option-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: add mode_option module parameter
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Small step toward unification of mode setting parameter.  This is required
to fix the Bugzilla's bug 9847

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/tdfxfb.c~tdfxfb-add-mode_option-module-parameter drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-add-mode_option-module-parameter
+++ a/drivers/video/tdfxfb.c
@@ -1426,6 +1426,8 @@ MODULE_LICENSE("GPL");
 module_param(hwcursor, int, 0644);
 MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
 			"(1=enable, 0=disable, default=1)");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disable MTRR support (default: enabled)");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

