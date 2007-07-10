From: akpm@linux-foundation.org
Subject: - powerpc-promc-remove-undef-printk.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:30 -0700
Message-ID: <200707101948.l6AJmUN6026008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757375AbXGJTsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     powerpc prom.c: remove #undef printk
has been removed from the -mm tree.  Its filename was
     powerpc-promc-remove-undef-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc prom.c: remove #undef printk
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/powerpc/kernel/prom.c~powerpc-promc-remove-undef-printk arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-promc-remove-undef-printk
+++ a/arch/powerpc/kernel/prom.c
@@ -1055,8 +1055,6 @@ void __init early_init_devtree(void *par
 	DBG(" <- early_init_devtree()\n");
 }
 
-#undef printk
-
 int of_n_addr_cells(struct device_node* np)
 {
 	const int *ip;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

git-powerpc.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
