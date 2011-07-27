From: akpm@linux-foundation.org
Subject: [merged] fault-injection-remove-nonexistent-function-extern.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:38 -0700
Message-ID: <201107271928.p6RJSPvd003302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999Ab1G0T2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: remove nonexistent function extern
has been removed from the -mm tree.  Its filename was
     fault-injection-remove-nonexistent-function-extern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection: remove nonexistent function extern
From: Akinobu Mita <akinobu.mita@gmail.com>

should_fail_srandom() does not exist.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/fault-inject.h~fault-injection-remove-nonexistent-function-extern include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-remove-nonexistent-function-extern
+++ a/include/linux/fault-inject.h
@@ -57,7 +57,6 @@ struct fault_attr {
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
-void should_fail_srandom(unsigned long entropy);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

