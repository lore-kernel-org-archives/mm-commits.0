From: akpm@linux-foundation.org
Subject: [merged] drivers-char-nozomic-fix-unused-variable-compiler-warning.patch removed from -mm tree
Date: Wed, 10 Nov 2010 12:13:16 -0800
Message-ID: <201011102015.oAAKFdP8003534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab0KJUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 15:15:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arun@bhanu.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/nozomi.c: fix unused variable compiler warning
has been removed from the -mm tree.  Its filename was
     drivers-char-nozomic-fix-unused-variable-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/nozomi.c: fix unused variable compiler warning
From: Arun Bhanu <arun@bhanu.net>

drivers/char/nozomi.c: In function `ntty_ioctl':
drivers/char/nozomi.c:1831:8: warning: unused variable `argp'

Signed-off-by: Arun Bhanu <arun@bhanu.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/nozomi.c~drivers-char-nozomic-fix-unused-variable-compiler-warning drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~drivers-char-nozomic-fix-unused-variable-compiler-warning
+++ a/drivers/char/nozomi.c
@@ -1828,7 +1828,6 @@ static int ntty_ioctl(struct tty_struct 
 		      unsigned int cmd, unsigned long arg)
 {
 	struct port *port = tty->driver_data;
-	void __user *argp = (void __user *)arg;
 	int rval = -ENOIOCTLCMD;
 
 	DBG1("******** IOCTL, cmd: %d", cmd);
_

Patches currently in -mm which might be from arun@bhanu.net are


