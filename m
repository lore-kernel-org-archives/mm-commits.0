From: akpm@osdl.org
Subject: + git-libata-all-forward-declare-struct-device.patch added to -mm tree
Date: Fri, 02 Feb 2007 18:07:10 -0800
Message-ID: <200702030208.l13289Xm027346@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52337 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946209AbXBCCIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 21:08:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, jeff@garzik.org


The patch titled
     git-libata-all: forward declare struct device
has been added to the -mm tree.  Its filename is
     git-libata-all-forward-declare-struct-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-libata-all: forward declare struct device
From: Andrew Morton <akpm@linux-foundation.org>

In file included from drivers/infiniband/hw/ipath/ipath_diag.c:44:
include/linux/io.h:35: warning: 'struct device' declared inside parameter list
include/linux/io.h:35: warning: its scope is only this definition or declaration

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/io.h~git-libata-all-forward-declare-struct-device include/linux/io.h
--- a/include/linux/io.h~git-libata-all-forward-declare-struct-device
+++ a/include/linux/io.h
@@ -22,6 +22,8 @@
 #include <asm/io.h>
 #include <asm/page.h>
 
+struct device;
+
 void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
git-md-accel-fixes.patch
git-libata-all-forward-declare-struct-device.patch
