From: akpm@linux-foundation.org
Subject: - submittingpatches-add-a-reference-to-andis-ols-paper.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:30 -0700
Message-ID: <200810182312.m9INCUFg028003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYJRXMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     SubmittingPatches: add a reference to Andi's OLS paper
has been removed from the -mm tree.  Its filename was
     submittingpatches-add-a-reference-to-andis-ols-paper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SubmittingPatches: add a reference to Andi's OLS paper
From: Andi Kleen <andi@firstfloor.org>

For this year's OLS I wrote a paper on successfull strategies to submit
difficult kernel patches.  Add a reference to it to SubmittingPatches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/SubmittingPatches~submittingpatches-add-a-reference-to-andis-ols-paper Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~submittingpatches-add-a-reference-to-andis-ols-paper
+++ a/Documentation/SubmittingPatches
@@ -672,4 +672,9 @@ Kernel Documentation/CodingStyle:
 
 Linus Torvalds's mail on the canonical patch format:
   <http://lkml.org/lkml/2005/4/7/183>
+
+Andi Kleen, "On submitting kernel patches"
+  Some strategies to get difficult or controversal changes in.
+  http://halobates.de/on-submitting-patches.pdf
+
 --
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
fix-documentation-of-sysrq-q.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
acpi-use-bcd2bin-bin2bcd.patch

