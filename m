From: akpm@linux-foundation.org
Subject: [merged] pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:41:55 -0700
Message-ID: <5390c803.jOGEJ3FAHCv51p17%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFETlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com

Subject: [merged] pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch removed from -mm tree
To: ak@linux.intel.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:41:55 -0700


The patch titled
     Subject: MAINTAINERS: pass on hwpoison maintainership to Naoya Horiguchi
has been removed from the -mm tree.  Its filename was
     pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: MAINTAINERS: pass on hwpoison maintainership to Naoya Horiguchi

Horiguchi-san has done most of the work on hwpoison in the last years and
he also does most of the reviewing.  So I'm passing on the hwpoison
maintainership to him.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~pass-on-hwpoison-maintainership-to-naoya-noriguchi MAINTAINERS
--- a/MAINTAINERS~pass-on-hwpoison-maintainership-to-naoya-noriguchi
+++ a/MAINTAINERS
@@ -4011,9 +4011,8 @@ S:	Odd Fixes
 F:	drivers/media/usb/hdpvr/
 
 HWPOISON MEMORY FAILURE HANDLING
-M:	Andi Kleen <andi@firstfloor.org>
+M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
 L:	linux-mm@kvack.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
 S:	Maintained
 F:	mm/memory-failure.c
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

