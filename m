From: akpm@linux-foundation.org
Subject: [merged]
 documentation-update-arch-list-in-the-memtest-entry.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:31:05 -0700
Message-ID: <552ebc79.T7yeKC09djswqAUo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update arch list in the 'memtest' entry
has been removed from the -mm tree.  Its filename was
     documentation-update-arch-list-in-the-memtest-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1989,7 +1989,7 @@ bytes respectively. Such letter suffixes
 			seconds.  Use this parameter to check at some
 			other rate.  0 disables periodic checking.
 
-	memtest=	[KNL,X86] Enable memtest
+	memtest=	[KNL,X86,ARM] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
 			Specifies the number of memtest passes to be
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

origin.patch

