From: akpm@linux-foundation.org
Subject: [merged]
 score-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:42 -0700
Message-ID: <51db1272.tyecdL23dTG+VfWv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GHT0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liqin.chen@sunplusct.com, lennox.wu@gmail.com, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] score-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,lennox.wu@gmail.com,liqin.chen@sunplusct.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:42 -0700


The patch titled
     Subject: score: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     score-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: score: normalize global variables exported by vmlinux.lds

Generate mandatory global variables _sdata in file vmlinux.lds.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/score/kernel/vmlinux.lds.S~score-normalize-global-variables-exported-by-vmlinuxlds arch/score/kernel/vmlinux.lds.S
--- a/arch/score/kernel/vmlinux.lds.S~score-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/score/kernel/vmlinux.lds.S
@@ -49,6 +49,7 @@ SECTIONS
 	}
 
 	. = ALIGN(16);
+	_sdata =  .;			/* Start of data section */
 	RODATA
 
 	EXCEPTION_TABLE(16)
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

