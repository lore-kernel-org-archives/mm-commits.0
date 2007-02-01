From: akpm@osdl.org
Subject: - fix-aioh-includes.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:11 -0800
Message-ID: <200702012256.l11MuBuT025449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbXBAW4a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@kvack.org, drepper@redhat.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: fix aio.h includes
has been removed from the -mm tree.  Its filename was
     fix-aioh-includes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: aio: fix aio.h includes
=46rom: Sbastien Dugu <sebastien.dugue@bull.net>

=46ix the double inclusion of linux/uio.h in linux/aio.h

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/aio.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/aio.h~fix-aioh-includes include/linux/aio.h
--- a/include/linux/aio.h~fix-aioh-includes
+++ a/include/linux/aio.h
@@ -7,7 +7,6 @@
 #include <linux/uio.h>
=20
 #include <asm/atomic.h>
-#include <linux/uio.h>
=20
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

fix-aioh-includes.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
