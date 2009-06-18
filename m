From: akpm@linux-foundation.org
Subject: [merged] ia64-msi_ia64c-dmar_msi_type-should-be-static.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:30 -0700
Message-ID: <200906181820.n5IIKUd8018040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbZFRSWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: msi_ia64.c dmar_msi_type should be static
has been removed from the -mm tree.  Its filename was
     ia64-msi_ia64c-dmar_msi_type-should-be-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch
sysctlc-remove-unused-variable.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-apic-io_apicc-dmar_msi_type-should-be-static.patch

