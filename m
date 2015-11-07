From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-mapping-tidy-up-dma_parms-default-handling-fix.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 16:16:30 -0800
Message-ID: <563d42de.4t96Ig3V4jumPCUE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbbKGAQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, robin.murphy@arm.com, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-tidy-up-dma_parms-default-handling-fix
has been removed from the -mm tree.  Its filename was
     dma-mapping-tidy-up-dma_parms-default-handling-fix.patch

This patch was dropped because it was folded into dma-mapping-tidy-up-dma_parms-default-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dma-mapping-tidy-up-dma_parms-default-handling-fix

dma-mapping.h needs sizes.h for SZ_64K

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling-fix
+++ a/include/linux/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
dma-mapping-tidy-up-dma_parms-default-handling.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

