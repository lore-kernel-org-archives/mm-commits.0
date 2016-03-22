From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-add-kcov-code-coverage-fix-2.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:57:37 -0700
Message-ID: <56f1b1c1.08ZSN9HRKQrSJLBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcCVU5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-kcov-code-coverage-fix-2
has been removed from the -mm tree.  Its filename was
     kernel-add-kcov-code-coverage-fix-2.patch

This patch was dropped because it was folded into kernel-add-kcov-code-coverage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-kcov-code-coverage-fix-2

unbreak allmodconfig

Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN Makefile~kernel-add-kcov-code-coverage-fix-2 Makefile
--- a/Makefile~kernel-add-kcov-code-coverage-fix-2
+++ a/Makefile
@@ -678,6 +678,7 @@ ifdef CONFIG_KCOV
   ifeq ($(call cc-option, $(CFLAGS_KCOV)),)
     $(warning Cannot use CONFIG_KCOV: \
              -fsanitize-coverage=trace-pc is not supported by compiler)
+    CFLAGS_KCOV =
   endif
 endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-add-kcov-code-coverage.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

