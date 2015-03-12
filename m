From: akpm@linux-foundation.org
Subject: + kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
 added to -mm tree
Date: Thu, 12 Mar 2015 13:41:57 -0700
Message-ID: <5501fa15.RCHtzQYDKo94HzdK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLUl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: memtest: update number of test patterns up to 17
has been added to the -mm tree.  Its filename is
     kconfig-memtest-update-number-of-test-patterns-up-to-17.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-memtest-update-number-of-test-patterns-up-to-17.patch

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
Subject: Kconfig: memtest: update number of test patterns up to 17

Additional test patterns for memtest were introduced since 63823126
"x86: memtest: add additional (regular) test patterns", but looks like
Kconfig was not updated that time.

Update Kconfig entry with the actual number of maximum test patterns.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~kconfig-memtest-update-number-of-test-patterns-up-to-17 lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-memtest-update-number-of-test-patterns-up-to-17
+++ a/lib/Kconfig.debug
@@ -1740,7 +1740,7 @@ config MEMTEST
 	        memtest=0, mean disabled; -- default
 	        memtest=1, mean do 1 test pattern;
 	        ...
-	        memtest=4, mean do 4 test patterns.
+	        memtest=17, mean do 17 test patterns.
 	  If you are unsure how to answer this question, answer N.
 
 source "samples/Kconfig"
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
linux-next.patch

