From: akpm@linux-foundation.org
Subject: + documentation-hwspinlocktxt-fix-typo.patch added to -mm tree
Date: Fri, 23 Aug 2013 15:37:30 -0700
Message-ID: <5217e42a.fNEq4mSAqkwih6ZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3HWWha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 18:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: + documentation-hwspinlocktxt-fix-typo.patch added to -mm tree
To: qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 15:37:30 -0700


The patch titled
     Subject: Documentation/hwspinlock.txt: fix typo
has been added to the -mm tree.  Its filename is
     documentation-hwspinlocktxt-fix-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-hwspinlocktxt-fix-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-hwspinlocktxt-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
documentation-memory-hotplugtxt-fix-typo.patch
documentation-hwspinlocktxt-fix-typo.patch
kexec-remove-unnecessary-return.patch

