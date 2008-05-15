From: akpm@linux-foundation.org
Subject: + drivers-atm-enih-remove-unused-macro-kernel_offset.patch added to -mm tree
Date: Thu, 15 May 2008 16:08:42 -0700
Message-ID: <200805152308.m4FN8gA3015251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEOXJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rautelap@gmail.com


The patch titled
     drivers/atm/eni.h: remove unused macro KERNEL_OFFSET
has been added to the -mm tree.  Its filename is
     drivers-atm-enih-remove-unused-macro-kernel_offset.patch

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
Subject: drivers/atm/eni.h: remove unused macro KERNEL_OFFSET
From: Pradeep Singh Rautela <rautelap@gmail.com>

KERNEL_OFFSET macro in eni.h is not required as it is not used anywhere. 
Remove the unused macro from eni.h header file.

Signed-off-by: Pradeep Singh <rautelap@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/eni.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/atm/eni.h~drivers-atm-enih-remove-unused-macro-kernel_offset drivers/atm/eni.h
--- a/drivers/atm/eni.h~drivers-atm-enih-remove-unused-macro-kernel_offset
+++ a/drivers/atm/eni.h
@@ -18,7 +18,6 @@
 #include "midway.h"
 
 
-#define KERNEL_OFFSET	0xC0000000	/* kernel 0x0 is at phys 0xC0000000 */
 #define DEV_LABEL	"eni"
 
 #define UBR_BUFFER	(128*1024)	/* UBR buffer size */
_

Patches currently in -mm which might be from rautelap@gmail.com are

drivers-atm-enih-remove-unused-macro-kernel_offset.patch

