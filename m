From: akpm@linux-foundation.org
Subject: - net-smc911x-shut-up-compiler-warnings.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:39 -0800
Message-ID: <200712172339.lBHNddEs008140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937543AbXLQXv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     net: smc911x: shut up compiler warnings
has been removed from the -mm tree.  Its filename was
     net-smc911x-shut-up-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-acpi.patch
hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch
git-netdev-all.patch
git-sh.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fb-defio-nopage.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
