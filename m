From: akpm@linux-foundation.org
Subject: - readahead-turn-on-by-default.patch removed from -mm tree
Date: Tue, 08 May 2007 01:16:10 -0700
Message-ID: <200705080816.l488GBIP019091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934501AbXEHIQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: turn on by default
has been removed from the -mm tree.  Its filename was
     readahead-turn-on-by-default.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: turn on by default
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Enable the adaptive readahead logic by default.

It helps collect more early testers, and is meant to be a -mm only patch.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~readahead-turn-on-by-default mm/Kconfig
--- a/mm/Kconfig~readahead-turn-on-by-default
+++ a/mm/Kconfig
@@ -173,7 +173,7 @@ config NR_QUICK
 #
 config ADAPTIVE_READAHEAD
 	bool "Adaptive file readahead (EXPERIMENTAL)"
-	default n
+	default y
 	depends on EXPERIMENTAL
 	help
 	  Readahead is a technique employed by the kernel in an attempt
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-turn-on-by-default.patch
