From: akpm@linux-foundation.org
Subject: + firmware-support-loading-into-a-pre-allocated-buffer-fix.patch
 added to -mm tree
Date: Thu, 16 Jun 2016 14:21:14 -0700
Message-ID: <5763184a.KHmnNlQ6u9pwlgDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbcFPVVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 17:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.boyd@linaro.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware-support-loading-into-a-pre-allocated-buffer-fix
has been added to the -mm tree.  Its filename is
     firmware-support-loading-into-a-pre-allocated-buffer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-support-loading-into-a-pre-allocated-buffer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-support-loading-into-a-pre-allocated-buffer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
firmware-support-loading-into-a-pre-allocated-buffer-fix.patch

