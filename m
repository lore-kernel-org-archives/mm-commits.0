From: akpm@linux-foundation.org
Subject: + misc-phantom-consistent-whitespace.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:28:25 -0800
Message-ID: <200802280728.m1S7SPtQ021629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbYB1H22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xsonnek@gmail.com, jirislaby@gmail.com


The patch titled
     Misc: phantom, consistent whitespace
has been added to the -mm tree.  Its filename is
     misc-phantom-consistent-whitespace.patch

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
Subject: Misc: phantom, consistent whitespace
From: jan sonnek <xsonnek@gmail.com>

Make it consistent with the rest of the header.

Signed-off-by: jan sonnek <xsonnek@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/phantom.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/phantom.h~misc-phantom-consistent-whitespace include/linux/phantom.h
--- a/include/linux/phantom.h~misc-phantom-consistent-whitespace
+++ a/include/linux/phantom.h
@@ -27,13 +27,13 @@ struct phm_regs {
 
 #define PH_IOC_MAGIC		'p'
 #define PHN_GET_REG		_IOWR(PH_IOC_MAGIC, 0, struct phm_reg *)
-#define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
+#define PHN_SET_REG		_IOW(PH_IOC_MAGIC, 1, struct phm_reg *)
 #define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
-#define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
+#define PHN_SET_REGS		_IOW(PH_IOC_MAGIC, 3, struct phm_regs *)
 /* this ioctl tells the driver, that the caller is not OpenHaptics and might
  * use improved registers update (no more phantom switchoffs when using
  * libphantom) */
-#define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
+#define PHN_NOT_OH		_IO(PH_IOC_MAGIC, 4)
 #define PHN_GETREG		_IOWR(PH_IOC_MAGIC, 5, struct phm_reg)
 #define PHN_SETREG		_IOW(PH_IOC_MAGIC, 6, struct phm_reg)
 #define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
_

Patches currently in -mm which might be from xsonnek@gmail.com are

misc-phantom-consistent-whitespace.patch
