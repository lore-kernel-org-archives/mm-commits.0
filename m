From: akpm@linux-foundation.org
Subject: + mm-move-memtest-under-mm-fix-fix.patch added to -mm tree
Date: Thu, 02 Apr 2015 13:54:50 -0700
Message-ID: <551dac9a.em/UCnz8vNUbkKSn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbDBUyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 16:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-memtest-under-mm-fix-fix
has been added to the -mm tree.  Its filename is
     mm-move-memtest-under-mm-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-memtest-under-mm-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-memtest-under-mm-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: mm-move-memtest-under-mm-fix-fix

It was noticed by Paul Bolle that patch above simply disables MEMTEST
altogether.  ?

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~mm-move-memtest-under-mm-fix-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-move-memtest-under-mm-fix-fix
+++ a/lib/Kconfig.debug
@@ -1734,7 +1734,7 @@ config TEST_UDELAY
 
 config MEMTEST
 	bool "Memtest"
-	depends on MEMBLOCK
+	depends on HAVE_MEMBLOCK
 	---help---
 	  This option adds a kernel parameter 'memtest', which allows memtest
 	  to be set.
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
mm-move-memtest-under-mm-fix.patch
mm-move-memtest-under-mm-fix-fix.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch

