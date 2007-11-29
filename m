From: akpm@linux-foundation.org
Subject: + net-smc911x-shut-up-compiler-warnings.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:02:26 -0800
Message-ID: <200711292102.lATL2QB6007239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761505AbXK2VCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jeff@garzik.org


The patch titled
     net: smc911x: shut up compiler warnings
has been added to the -mm tree.  Its filename is
     net-smc911x-shut-up-compiler-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: smc911x: shut up compiler warnings
From: Paul Mundt <lethal@linux-sh.org>

Trivial fix to shut up gcc.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/smc911x.h~net-smc911x-shut-up-compiler-warnings drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~net-smc911x-shut-up-compiler-warnings
+++ a/drivers/net/smc911x.h
@@ -76,7 +76,7 @@
 
 
 
-#if	 SMC_USE_PXA_DMA
+#ifdef SMC_USE_PXA_DMA
 #define SMC_USE_DMA
 
 /*
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
net-smc911x-only-enable-for-mpr2-on-sh.patch
net-smc911x-shut-up-compiler-warnings.patch
git-sh.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
kernel-printkc-concerns-about-the-console-handover.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
