From: akpm@linux-foundation.org
Subject: + uml-mmapper_kern-needs-module_license.patch added to -mm tree
Date: Wed, 15 Dec 2010 14:29:53 -0800
Message-ID: <201012152229.oBFMTrel009717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0LOWaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 17:30:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, glonnon@ridgerun.com, jdike@addtoit.com


The patch titled
     uml: mmapper_kern needs MODULE_LICENSE
has been added to the -mm tree.  Its filename is
     uml-mmapper_kern-needs-module_license.patch

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
Subject: uml: mmapper_kern needs MODULE_LICENSE
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing MODULE_LICENSE():

WARNING: modpost: missing MODULE_LICENSE() in arch/um/drivers/mmapper_kern.o

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Lonnon <glonnon@ridgerun.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mmapper_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/mmapper_kern.c~uml-mmapper_kern-needs-module_license arch/um/drivers/mmapper_kern.c
--- a/arch/um/drivers/mmapper_kern.c~uml-mmapper_kern-needs-module_license
+++ a/arch/um/drivers/mmapper_kern.c
@@ -137,3 +137,4 @@ module_exit(mmapper_exit);
 
 MODULE_AUTHOR("Greg Lonnon <glonnon@ridgerun.com>");
 MODULE_DESCRIPTION("DSPLinux simulator mmapper driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

