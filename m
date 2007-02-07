From: akpm@linux-foundation.org
Subject: - git-libata-all-forward-declare-struct-device.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:30 -0800
Message-ID: <200702071952.l17JqU9A025245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXBGTwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     git-libata-all: forward declare struct device
has been removed from the -mm tree.  Its filename was
     git-libata-all-forward-declare-struct-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
mm-vm_insert_pfn-tidy.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
