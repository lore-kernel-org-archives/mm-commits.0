From: akpm@linux-foundation.org
Subject: + tpm-correct-email-address-for-tpm_infineon-driver.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:19:50 -0800
Message-ID: <200902030819.n138JoTU031647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZBCIUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:20:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.selhorst@sirrix.com


The patch titled
     tpm: correct email address for tpm_infineon-driver
has been added to the -mm tree.  Its filename is
     tpm-correct-email-address-for-tpm_infineon-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: correct email address for tpm_infineon-driver
From: Marcel Selhorst <m.selhorst@sirrix.com>

Update my email address.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                     |    4 ++--
 drivers/char/tpm/tpm_infineon.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~tpm-correct-email-address-for-tpm_infineon-driver MAINTAINERS
--- a/MAINTAINERS~tpm-correct-email-address-for-tpm_infineon-driver
+++ a/MAINTAINERS
@@ -4314,8 +4314,8 @@ P:	Rajiv Andrade
 M:	srajiv@linux.vnet.ibm.com
 W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
-M:	tpm@selhorst.net
-W:	http://www.prosec.rub.de/tpm/
+M:	m.selhorst@sirrix.com
+W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
diff -puN drivers/char/tpm/tpm_infineon.c~tpm-correct-email-address-for-tpm_infineon-driver drivers/char/tpm/tpm_infineon.c
--- a/drivers/char/tpm/tpm_infineon.c~tpm-correct-email-address-for-tpm_infineon-driver
+++ a/drivers/char/tpm/tpm_infineon.c
@@ -4,7 +4,7 @@
  * SLD 9630 TT 1.1 and SLB 9635 TT 1.2 Trusted Platform Module
  * Specifications at www.trustedcomputinggroup.org
  *
- * Copyright (C) 2005, Marcel Selhorst <selhorst@crypto.rub.de>
+ * Copyright (C) 2005, Marcel Selhorst <m.selhorst@sirrix.com>
  * Sirrix AG - security technologies, http://www.sirrix.com and
  * Applied Data Security Group, Ruhr-University Bochum, Germany
  * Project-Homepage: http://www.prosec.rub.de/tpm
@@ -636,7 +636,7 @@ static void __exit cleanup_inf(void)
 module_init(init_inf);
 module_exit(cleanup_inf);
 
-MODULE_AUTHOR("Marcel Selhorst <selhorst@crypto.rub.de>");
+MODULE_AUTHOR("Marcel Selhorst <m.selhorst@sirrix.com>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
 MODULE_VERSION("1.9");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from m.selhorst@sirrix.com are

tpm-correct-email-address-for-tpm_infineon-driver.patch

