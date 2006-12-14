From: akpm@osdl.org
Subject: - appldata_mem-dependes-on-vm-counters.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:11:04 -0800
Message-ID: <200612140611.kBE6B4Td002032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbWLNGLZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     appldata_mem dependes on vm counters
has been removed from the -mm tree.  Its filename was
     appldata_mem-dependes-on-vm-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: appldata_mem dependes on vm counters
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/s390/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/Kconfig~appldata_mem-dependes-on-vm-counters arch/s390/Kconfig
--- a/arch/s390/Kconfig~appldata_mem-dependes-on-vm-counters
+++ a/arch/s390/Kconfig
@@ -407,7 +407,7 @@ config APPLDATA_BASE
 
 config APPLDATA_MEM
 	tristate "Monitor memory management statistics"
-	depends on APPLDATA_BASE
+	depends on APPLDATA_BASE && VM_EVENT_COUNTERS
 	help
 	  This provides memory management related data to the Linux - VM Monitor
 	  Stream, like paging/swapping rate, memory utilisation, etc.
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

