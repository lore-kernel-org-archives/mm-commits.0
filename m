From: akpm@linux-foundation.org
Subject: [folded-merged]
 uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:22:26 -0800
Message-ID: <563c0ee2.MtLxT3Z3W3c6WxOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix
has been removed from the -mm tree.  Its filename was
     uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch

This patch was dropped because it was folded into uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/alignment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mm/alignment.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix
+++ a/arch/arm/mm/alignment.c
@@ -803,7 +803,7 @@ do_alignment(unsigned long addr, unsigne
 			}
 		}
 	} else {
-		fault = probe_kernel_address(instrptr, instr);
+		fault = probe_kernel_address((void *)instrptr, instr);
 		instr = __mem_to_opcode_arm(instr);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

