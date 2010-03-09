From: akpm@linux-foundation.org
Subject: [merged] includecheck-fix-for-kernel-paramsc.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:20 -0800
Message-ID: <201003091906.o29J6KR0031248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab0CITHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, andre.goddard@gmail.com, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     includecheck fix for kernel/params.c
has been removed from the -mm tree.  Its filename was
     includecheck-fix-for-kernel-paramsc.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: includecheck fix for kernel/params.c
=46rom: Jaswinder Singh Rajput <jaswinder@kernel.org>

=46ix the following 'make includecheck' warning:
  kernel/params.c: linux/string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/params.c~includecheck-fix-for-kernel-paramsc kernel/pa=
rams.c
--- a/kernel/params.c~includecheck-fix-for-kernel-paramsc
+++ a/kernel/params.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
-#include <linux/string.h>
=20
 #if 0
 #define DEBUGP printk
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
xtensa-includecheck-fix-vectorss.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
