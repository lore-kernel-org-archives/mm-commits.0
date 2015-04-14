From: akpm@linux-foundation.org
Subject: [folded-merged] mm-move-memtest-under-mm-fix-fix.patch removed
 from -mm tree
Date: Tue, 14 Apr 2015 15:19:57 -0700
Message-ID: <552d928d.RuCacV9Q1hwdol0Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbbDNWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-memtest-under-mm-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-move-memtest-under-mm-fix-fix.patch

This patch was dropped because it was folded into mm-move-memtest-under-mm.patch

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
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch

