From: akpm@linux-foundation.org
Subject: - linux-fsh-include-linux-pathh.patch removed from -mm tree
Date: Mon, 28 Jul 2008 21:38:59 -0700
Message-ID: <200807290438.m6T4cxLQ014462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbYG2EjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niels.devos@wincor-nixdorf.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     linux/fs.h: include linux/path.h
has been removed from the -mm tree.  Its filename was
     linux-fsh-include-linux-pathh.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/fs.h: include linux/path.h
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

In linux/fs.h 'struct path' is being used. Therefore linux/path.h should
be included.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/fs.h~linux-fsh-include-linux-pathh include/linux/fs.h
--- a/include/linux/fs.h~linux-fsh-include-linux-pathh
+++ a/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/path.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

origin.patch
linux-fsh-include-linux-pathh.patch

