From: akpm@linux-foundation.org
Subject: - fix-wrong-filename-reference-in-drivers-testingtxt.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:26 -0700
Message-ID: <200710180701.l9I71Qp2031176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761418AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Fix wrong filename reference in drivers-testing.txt
has been removed from the -mm tree.  Its filename was
     fix-wrong-filename-reference-in-drivers-testingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix wrong filename reference in drivers-testing.txt
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/drivers-testing.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/power/drivers-testing.txt~fix-wrong-filename-reference-in-drivers-testingtxt Documentation/power/drivers-testing.txt
--- a/Documentation/power/drivers-testing.txt~fix-wrong-filename-reference-in-drivers-testingtxt
+++ a/Documentation/power/drivers-testing.txt
@@ -14,8 +14,8 @@ the machine's BIOS.
 Of course, for this purpose the test system has to be known to suspend and
 resume without the driver being tested.  Thus, if possible, you should first
 resolve all suspend/resume-related problems in the test system before you start
-testing the new driver.  Please see Documents/power/basic-pm-debugging.txt for
-more information about the debugging of suspend/resume functionality.
+testing the new driver.  Please see Documentation/power/basic-pm-debugging.txt
+for more information about the debugging of suspend/resume functionality.
 
 2. Testing the driver
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
netport_conc-fix-build-errors-and-warnings.patch
au1100fb-fix-modpost-warnings.patch
logoc-get-rid-of-mips_machgroup.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
