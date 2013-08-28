From: akpm@linux-foundation.org
Subject: [merged] documentation-memory-hotplugtxt-fix-typo.patch removed
 from -mm tree
Date: Wed, 28 Aug 2013 13:52:27 -0700
Message-ID: <521e630b.iYHZp7mAHnMnTKNF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3H1Uw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 16:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [merged] documentation-memory-hotplugtxt-fix-typo.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 13:52:27 -0700


The patch titled
     Subject: Documentation/memory-hotplug.txt: fix typo
has been removed from the -mm tree.  Its filename was
     documentation-memory-hotplugtxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
mm-hotplug-remove-unnecessary-bug_on-in-__offline_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch
mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch
kexec-remove-unnecessary-return.patch

