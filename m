From: akpm@linux-foundation.org
Subject: - x86_64-remove-unusued-flags-variable.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:56 -0800
Message-ID: <200703052355.l25NtuqO005215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949AbXCEX4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove unusued 'flags' variable
has been removed from the -mm tree.  Its filename was
     x86_64-remove-unusued-flags-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove unusued 'flags' variable
From: David Rientjes <rientjes@google.com>

Removes unused 'flags' variable from setup_IO_APIC_irq().

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-remove-unusued-flags-variable arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-remove-unusued-flags-variable
+++ a/arch/x86_64/kernel/io_apic.c
@@ -789,7 +789,6 @@ static void setup_IO_APIC_irq(int apic, 
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
-	unsigned long flags;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-map-fake-nodes-to-real-nodes-fix.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
