From: akpm@linux-foundation.org
Subject: + documentation-update-arch-list-in-the-memtest-entry.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:41:59 -0700
Message-ID: <5501fa17.xXg9hfP42ITlTzc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLUmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update arch list in the 'memtest' entry
has been added to the -mm tree.  Its filename is
     documentation-update-arch-list-in-the-memtest-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-arch-list-in-the-memtest-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-arch-list-in-the-memtest-entry.patch

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
Subject: Documentation: update arch list in the 'memtest' entry

Since arm64/arm support memtest command line option update the "memtest"
entry.

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

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~documentation-update-arch-list-in-the-memtest-entry Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-update-arch-list-in-the-memtest-entry
+++ a/Documentation/kernel-parameters.txt
@@ -1988,7 +1988,7 @@ bytes respectively. Such letter suffixes
 			seconds.  Use this parameter to check at some
 			other rate.  0 disables periodic checking.
 
-	memtest=	[KNL,X86] Enable memtest
+	memtest=	[KNL,X86,ARM] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
 			Specifies the number of memtest passes to be
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
linux-next.patch

