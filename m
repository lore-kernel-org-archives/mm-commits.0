From: akpm@osdl.org
Subject: + appldata_mem-dependes-on-vm-counters.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:01:05 -0800
Message-ID: <200612102001.kBAK15Tl001649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762462AbWLJUBR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     appldata_mem dependes on vm counters
has been added to the -mm tree.  Its filename is
     appldata_mem-dependes-on-vm-counters.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -411,7 +411,7 @@ config APPLDATA_BASE
 
 config APPLDATA_MEM
 	tristate "Monitor memory management statistics"
-	depends on APPLDATA_BASE
+	depends on APPLDATA_BASE && VM_EVENT_COUNTERS
 	help
 	  This provides memory management related data to the Linux - VM Monitor
 	  Stream, like paging/swapping rate, memory utilisation, etc.
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
config_computone-should-depend-on-isaeisapci.patch
appldata_mem-dependes-on-vm-counters.patch
uml-problems-with-linux-ioh.patch
missing-includes-in-hilkbd.patch
hci-endianness-annotations.patch
lockd-endianness-annotations-rebased.patch
slab-leaks3-default-y.patch

