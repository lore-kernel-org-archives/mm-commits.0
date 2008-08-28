From: akpm@linux-foundation.org
Subject: + hid-fix-grammo-in-hid_compat-kconfig-help-text.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:44:50 -0700
Message-ID: <200808280344.m7S3iooS005631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbYH1DpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, jikos@jikos.cz, jirislaby@gmail.com


The patch titled
     hid: fix grammo in HID_COMPAT Kconfig help text
has been added to the -mm tree.  Its filename is
     hid-fix-grammo-in-hid_compat-kconfig-help-text.patch

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
hid-fix-grammo-in-hid_compat-kconfig-help-text.patch

