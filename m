From: akpm@linux-foundation.org
Subject: + submittingpatches-add-a-reference-to-andis-ols-paper.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:17:43 -0700
Message-ID: <200810102317.m9ANHhF4015369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbYJJXRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     SubmittingPatches: add a reference to Andi's OLS paper
has been added to the -mm tree.  Its filename is
     submittingpatches-add-a-reference-to-andis-ols-paper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

git-tip.patch
git-pci.patch
git-ext4.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
misdn-misc-timerdev-fixes-fix.patch
make-taint-bit-reliable-v3.patch
make-taint-bit-reliable-v3-fix.patch
taint-fix-kernel-doc.patch
submittingpatches-add-a-reference-to-andis-ols-paper.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
acpi-use-bcd2bin-bin2bcd.patch
profile-likely-unlikely-macros.patch

