From: akpm@linux-foundation.org
Subject: + ia64-msi_ia64c-dmar_msi_type-should-be-static.patch added to -mm tree
Date: Thu, 28 May 2009 01:32:54 -0700
Message-ID: <200905280832.n4S8WsYF026926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbZE1Ie1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 04:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, tony.luck@intel.com


The patch titled
     ia64: msi_ia64.c dmar_msi_type should be static
has been added to the -mm tree.  Its filename is
     ia64-msi_ia64c-dmar_msi_type-should-be-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: msi_ia64.c dmar_msi_type should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/msi_ia64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/msi_ia64.c~ia64-msi_ia64c-dmar_msi_type-should-be-static arch/ia64/kernel/msi_ia64.c
--- a/arch/ia64/kernel/msi_ia64.c~ia64-msi_ia64c-dmar_msi_type-should-be-static
+++ a/arch/ia64/kernel/msi_ia64.c
@@ -158,7 +158,7 @@ static int dmar_msi_set_affinity(unsigne
 }
 #endif /* CONFIG_SMP */
 
-struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
ia64-msi_ia64c-dmar_msi_type-should-be-static.patch
documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch
documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch
sysctlc-remove-unused-variable.patch

