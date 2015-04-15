From: akpm@linux-foundation.org
Subject: [merged]
 kconfig-memtest-update-number-of-test-patterns-up-to-17.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 12:31:02 -0700
Message-ID: <552ebc76.3B46InHUcvR6LQta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: memtest: update number of test patterns up to 17
has been removed from the -mm tree.  Its filename was
     kconfig-memtest-update-number-of-test-patterns-up-to-17.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1754,7 +1754,7 @@ config MEMTEST
 	        memtest=0, mean disabled; -- default
 	        memtest=1, mean do 1 test pattern;
 	        ...
-	        memtest=4, mean do 4 test patterns.
+	        memtest=17, mean do 17 test patterns.
 	  If you are unsure how to answer this question, answer N.
 
 source "samples/Kconfig"
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

origin.patch

