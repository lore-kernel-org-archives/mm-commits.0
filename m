From: akpm@linux-foundation.org
Subject: [merged]
 documentation-vm-pagemaptxt-correct-location-of-page-types-tool.patch
 removed from -mm tree
Date: Mon, 13 Apr 2015 12:58:18 -0700
Message-ID: <552c1fda.W5FtqNteqtRO2BnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbDMT6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Apr 2015 15:58:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rwright@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/pagemap.txt: correct location of page-types tool
has been removed from the -mm tree.  Its filename was
     documentation-vm-pagemaptxt-correct-location-of-page-types-tool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Wright <rwright@hp.com>
Subject: Documentation/vm/pagemap.txt: correct location of page-types tool

The page-types tool was relocated to tools/vm in the 3.4 kernel timeframe.

Signed-off-by: Randy Wright <rwright@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/pagemap.txt~documentation-vm-pagemaptxt-correct-location-of-page-types-tool Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~documentation-vm-pagemaptxt-correct-location-of-page-types-tool
+++ a/Documentation/vm/pagemap.txt
@@ -131,7 +131,8 @@ Short descriptions to the page flags:
 13. SWAPCACHE   page is mapped to swap space, ie. has an associated swap entry
 14. SWAPBACKED  page is backed by swap/RAM
 
-The page-types tool in this directory can be used to query the above flags.
+The page-types tool in the tools/vm directory can be used to query the
+above flags.
 
 Using pagemap to do something useful:
 
_

Patches currently in -mm which might be from rwright@hp.com are

linux-next.patch

