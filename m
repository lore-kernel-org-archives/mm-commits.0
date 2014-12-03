From: akpm@linux-foundation.org
Subject: [merged]
 lib-genallocc-export-devm_gen_pool_create-for-modules.patch removed from
 -mm tree
Date: Wed, 03 Dec 2014 13:29:50 -0800
Message-ID: <547f80ce.Tx44vBZrHPsslmFm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCV3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 16:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@xilinx.com, catalin.marinas@arm.com, lauraa@codeaurora.org, olof@lixom.net, p.zabel@pengutronix.de, prabhakar.csengg@gmail.com, vladimir_zapolskiy@mentor.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: export devm_gen_pool_create() for modules
has been removed from the -mm tree.  Its filename was
     lib-genallocc-export-devm_gen_pool_create-for-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: lib/genalloc.c: export devm_gen_pool_create() for modules

Modules can use this function for creating pool.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/genalloc.c~lib-genallocc-export-devm_gen_pool_create-for-modules lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-export-devm_gen_pool_create-for-modules
+++ a/lib/genalloc.c
@@ -598,6 +598,7 @@ struct gen_pool *devm_gen_pool_create(st
 
 	return pool;
 }
+EXPORT_SYMBOL(devm_gen_pool_create);
 
 /**
  * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
linux-next.patch

