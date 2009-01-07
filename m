From: akpm@linux-foundation.org
Subject: - binfmtsh-include-listh.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:29 -0800
Message-ID: <200901072217.n07MHT0J017093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbZAGWbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     binfmts.h: include list.h
has been removed from the -mm tree.  Its filename was
     binfmtsh-include-listh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmts.h: include list.h
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

linux_binfmt uses list_head, so list.h is needed.

[akpm@linux-foundation.org: fix `make headerscheck']
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/binfmts.h~binfmtsh-include-listh include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmtsh-include-listh
+++ a/include/linux/binfmts.h
@@ -18,6 +18,7 @@ struct pt_regs;
 #define BINPRM_BUF_SIZE 128
 
 #ifdef __KERNEL__
+#include <linux/list.h>
 
 #define CORENAME_MAX_SIZE 128
 
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

origin.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

