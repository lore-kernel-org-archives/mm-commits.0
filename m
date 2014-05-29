From: akpm@linux-foundation.org
Subject: + pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch added
 to -mm tree
Date: Thu, 29 May 2014 15:10:29 -0700
Message-ID: <5387b055.2sJ+x8TV7Y3tLV/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaE2WKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 18:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com

Subject: + pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch added to -mm tree
To: ak@linux.intel.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 15:10:29 -0700


The patch titled
     Subject: MAINTAINERS: pass on hwpoison maintainership to Naoya Horiguchi
has been added to the -mm tree.  Its filename is
     pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4015,9 +4015,8 @@ S:	Odd Fixes
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

pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

