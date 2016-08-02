From: akpm@linux-foundation.org
Subject: [folded-merged]
 firmware-support-loading-into-a-pre-allocated-buffer-fix.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:44:05 -0700
Message-ID: <57a10615.CXQz8biqPp/j8qiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbcHBUoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.boyd@linaro.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware-support-loading-into-a-pre-allocated-buffer-fix
has been removed from the -mm tree.  Its filename was
     firmware-support-loading-into-a-pre-allocated-buffer-fix.patch

This patch was dropped because it was folded into firmware-support-loading-into-a-pre-allocated-buffer.patch

------------------------------------------------------
From: Stephen Boyd <stephen.boyd@linaro.org>
Subject: firmware-support-loading-into-a-pre-allocated-buffer-fix

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/firmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/firmware.h~firmware-support-loading-into-a-pre-allocated-buffer-fix include/linux/firmware.h
--- a/include/linux/firmware.h~firmware-support-loading-into-a-pre-allocated-buffer-fix
+++ a/include/linux/firmware.h
@@ -78,7 +78,7 @@ static inline int request_firmware_direc
 }
 
 static inline int request_firmware_into_buf(const struct firmware **firmware_p,
-	const char *name, struct device *device, void *buf, size_t size);
+	const char *name, struct device *device, void *buf, size_t size)
 {
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from stephen.boyd@linaro.org are

firmware-consolidate-kmap-read-write-logic.patch
firmware-support-loading-into-a-pre-allocated-buffer.patch

