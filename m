From: akpm@linux-foundation.org
Subject: + fix-typo-in-the-firmware_in_kernel-help.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:49:33 -0700
Message-ID: <200809192249.m8JMnXWi010479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYISWtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albertito@blitiri.com.ar


The patch titled
     Fix typo in the FIRMWARE_IN_KERNEL help
has been added to the -mm tree.  Its filename is
     fix-typo-in-the-firmware_in_kernel-help.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix typo in the FIRMWARE_IN_KERNEL help
From: Alberto Bertogli <albertito@blitiri.com.ar>

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/Kconfig~fix-typo-in-the-firmware_in_kernel-help drivers/base/Kconfig
--- a/drivers/base/Kconfig~fix-typo-in-the-firmware_in_kernel-help
+++ a/drivers/base/Kconfig
@@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which usees request_firmare() and ships its
+	  every driver which uses request_firmare() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 
_

Patches currently in -mm which might be from albertito@blitiri.com.ar are

fix-typo-in-the-firmware_in_kernel-help.patch

