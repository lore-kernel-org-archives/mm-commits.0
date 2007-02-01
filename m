From: akpm@osdl.org
Subject: + fix-aioh-includes.patch added to -mm tree
Date: Thu, 01 Feb 2007 15:04:36 -0800
Message-ID: <200702012304.l11N4aRJ025694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422724AbXBAXGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 18:06:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: fix aio.h includes
has been added to the -mm tree.  Its filename is
     fix-aioh-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: fix aio.h includes
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

=46ix the double inclusion of linux/uio.h in linux/aio.h

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/aio.h |    1 -
 1 files changed, 1 deletion(-)

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

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
