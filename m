From: akpm@linux-foundation.org
Subject: [merged]
 fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:10:46 -0700
Message-ID: <57a233a6.R+Cyiv/H8Scyh7Js%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbcHCSVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Valdis.Kletnieks@vt.edu, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/radix-tree/linux/gfp.h: fix bitrotted value
has been removed from the -mm tree.  Its filename was
     fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: tools/testing/radix-tree/linux/gfp.h: fix bitrotted value

Apparently, the tools/testing version dates to a few flags ago, and we've
sprouted 4 new ones since.  Keep in sync with the value in the main
tree...

Link: http://lkml.kernel.org/r/23400.1469702675@turing-police.cc.vt.edu
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/linux/gfp.h~fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph tools/testing/radix-tree/linux/gfp.h
--- a/tools/testing/radix-tree/linux/gfp.h~fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -1,7 +1,7 @@
 #ifndef _GFP_H
 #define _GFP_H
 
-#define __GFP_BITS_SHIFT 22
+#define __GFP_BITS_SHIFT 26
 #define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 #define __GFP_WAIT 1
 #define __GFP_ACCOUNT 0
_

Patches currently in -mm which might be from Valdis.Kletnieks@vt.edu are


