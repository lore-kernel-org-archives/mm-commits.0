From: akpm@linux-foundation.org
Subject: [merged] documentation-hwspinlocktxt-fix-typo.patch removed from
 -mm tree
Date: Wed, 28 Aug 2013 13:52:29 -0700
Message-ID: <521e630d.ZM511eC6qn3LvAi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3H1Uw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 16:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [merged] documentation-hwspinlocktxt-fix-typo.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 13:52:29 -0700


The patch titled
     Subject: Documentation/hwspinlock.txt: fix typo
has been removed from the -mm tree.  Its filename was
     documentation-hwspinlocktxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: Documentation/hwspinlock.txt: fix typo

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwspinlock.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/hwspinlock.txt~documentation-hwspinlocktxt-fix-typo Documentation/hwspinlock.txt
--- a/Documentation/hwspinlock.txt~documentation-hwspinlocktxt-fix-typo
+++ a/Documentation/hwspinlock.txt
@@ -241,7 +241,7 @@ int hwspinlock_example2(void)
      locks).
      Should be called from a process context (this function might sleep).
      Returns the address of hwspinlock on success, or NULL on error (e.g.
-     if the hwspinlock is sill in use).
+     if the hwspinlock is still in use).
 
 5. Important structs
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

linux-next.patch
mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
kexec-remove-unnecessary-return.patch

