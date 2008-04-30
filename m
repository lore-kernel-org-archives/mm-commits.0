From: akpm@linux-foundation.org
Subject: - misc-phantom-consistent-whitespace.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:15 -0700
Message-ID: <200804300540.m3U5eFJV028944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYD3FkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xsonnek@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, consistent whitespace
has been removed from the -mm tree.  Its filename was
     misc-phantom-consistent-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

