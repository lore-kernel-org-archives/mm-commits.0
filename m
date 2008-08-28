From: akpm@linux-foundation.org
Subject: - hid-fix-grammo-in-hid_compat-kconfig-help-text.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:49:03 -0700
Message-ID: <200808282149.m7SLn31W016160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbYH1VtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, jikos@jikos.cz, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hid: fix grammo in HID_COMPAT Kconfig help text
has been removed from the -mm tree.  Its filename was
     hid-fix-grammo-in-hid_compat-kconfig-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: fix grammo in HID_COMPAT Kconfig help text
From: Alex Chiang <achiang@hp.com>

The Kconfig option for HID_COMPAT should read "lose", not "loose".

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/Kconfig~hid-fix-grammo-in-hid_compat-kconfig-help-text drivers/hid/Kconfig
--- a/drivers/hid/Kconfig~hid-fix-grammo-in-hid_compat-kconfig-help-text
+++ a/drivers/hid/Kconfig
@@ -78,7 +78,7 @@ config HID_COMPAT
 	support of module loading through aliases and also old
 	module-init-tools which can't handle hid bus, choose Y here. Otherwise
 	say N. If you say N and your userspace is old enough, the only
-	functionality you loose is modules autoloading.
+	functionality you lose is modules autoloading.
 
 	If unsure, say Y.
 
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

