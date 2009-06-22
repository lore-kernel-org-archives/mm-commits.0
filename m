From: akpm@linux-foundation.org
Subject: [merged] x86-apic-io_apicc-dmar_msi_type-should-be-static.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:01:06 -0700
Message-ID: <200906221701.n5MH16IG010494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302AbZFVRKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86: apic/io_apic.c dmar_msi_type should be static
has been removed from the -mm tree.  Its filename was
     x86-apic-io_apicc-dmar_msi_type-should-be-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3565,7 +3565,7 @@ static int dmar_msi_set_affinity(unsigne
 
 #endif /* CONFIG_SMP */
 
-struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch

