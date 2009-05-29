From: akpm@linux-foundation.org
Subject: + x86-apic-io_apicc-dmar_msi_type-should-be-static.patch added to -mm tree
Date: Fri, 29 May 2009 14:30:30 -0700
Message-ID: <200905292130.n4TLUUgQ032504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbZE2Vbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 17:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     x86: apic/io_apic.c dmar_msi_type should be static
has been added to the -mm tree.  Its filename is
     x86-apic-io_apicc-dmar_msi_type-should-be-static.patch

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
Subject: x86: apic/io_apic.c dmar_msi_type should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/apic/io_apic.c~x86-apic-io_apicc-dmar_msi_type-should-be-static arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~x86-apic-io_apicc-dmar_msi_type-should-be-static
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -3538,7 +3538,7 @@ static int dmar_msi_set_affinity(unsigne
 
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
x86-apic-io_apicc-dmar_msi_type-should-be-static.patch
ia64-msi_ia64c-dmar_msi_type-should-be-static.patch
documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch
documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch
sysctlc-remove-unused-variable.patch

