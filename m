From: akpm@linux-foundation.org
Subject: - pm3fb-change-option-mode-to-mode_option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:01 -0700
Message-ID: <200804282158.m3SLw1JG018447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934631AbYD1V6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     pm3fb: change option mode to mode_option
has been removed from the -mm tree.  Its filename was
     pm3fb-change-option-mode-to-mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm3fb: change option mode to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add the option "mode_option".

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/pm3fb.c~pm3fb-change-option-mode-to-mode_option drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-change-option-mode-to-mode_option
+++ a/drivers/video/pm3fb.c
@@ -1571,6 +1571,8 @@ module_exit(pm3fb_exit);
 #endif
 module_init(pm3fb_init);
 
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "Disable acceleration");
 module_param(hwcursor, int, 0644);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

