From: akpm@linux-foundation.org
Subject: [merged] libcrc32c-fix-build-warning.patch removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:22 -0800
Message-ID: <56a1628e.zRtr2cUWEWdXFk8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbcAUW6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/libcrc32c.c: fix build warning
has been removed from the -mm tree.  Its filename was
     libcrc32c-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: lib/libcrc32c.c: fix build warning

Fix the following build warning:

lib/libcrc32c.c:42:5: warning: no previous prototype for "crc32c" [-Wmissing-prototypes]
 u32 crc32c(u32 crc, const void *address, unsigned int length)
     ^

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/libcrc32c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/libcrc32c.c~libcrc32c-fix-build-warning lib/libcrc32c.c
--- a/lib/libcrc32c.c~libcrc32c-fix-build-warning
+++ a/lib/libcrc32c.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/crc32c.h>
 
 static struct crypto_shash *tfm;
 
_

Patches currently in -mm which might be from jdelvare@suse.de are


