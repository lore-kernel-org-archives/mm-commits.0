From: akpm@linux-foundation.org
Subject: + documentation-memory-hotplugtxt-fix-typo.patch added to -mm
 tree
Date: Thu, 22 Aug 2013 15:30:05 -0700
Message-ID: <521690ed.eKRZGAsoELJQeVUG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3HVWaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: + documentation-memory-hotplugtxt-fix-typo.patch added to -mm tree
To: qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:30:05 -0700


The patch titled
     Subject: Documentation/memory-hotplug.txt: fix typo
has been added to the -mm tree.  Its filename is
     documentation-memory-hotplugtxt-fix-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-memory-hotplugtxt-fix-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-memory-hotplugtxt-fix-typo.patch

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
Subject: Documentation/memory-hotplug.txt: fix typo

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/memory-hotplug.txt~documentation-memory-hotplugtxt-fix-typo Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~documentation-memory-hotplugtxt-fix-typo
+++ a/Documentation/memory-hotplug.txt
@@ -163,7 +163,7 @@ a recent addition and not present on old
                     at read:  contains online/offline state of memory.
                     at write: user can specify "online_kernel",
                     "online_movable", "online", "offline" command
-                    which will be performed on al sections in the block.
+                    which will be performed on all sections in the block.
 'phys_device'     : read-only: designed to show the name of physical memory
                     device.  This is not well implemented now.
 'removable'       : read-only: contains an integer value indicating
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
documentation-memory-hotplugtxt-fix-typo.patch
kexec-remove-unnecessary-return.patch

