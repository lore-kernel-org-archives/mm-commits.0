From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-debug_wx-support-fix-2.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:24:20 -0700
Message-ID: <20200603222420.XOZpWnOSF%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgFCWYV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:24:21 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm: remove the specific name of arm64
has been removed from the -mm tree.  Its filename was
     mm-add-debug_wx-support-fix-2.patch

This patch was dropped because it was folded into mm-add-debug_wx-support.patch

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: mm: remove the specific name of arm64

UXN is the name of arm64 page-table descriptors.

Link: http://lkml.kernel.org/r/3a6a92ecedc54e1d0fc941398e63d504c2cd5611.1589178399.git.zong.li@sifive.com
Signed-off-by: Zong Li <zong.li@sifive.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/Kconfig.debug~mm-add-debug_wx-support-fix-2
+++ a/mm/Kconfig.debug
@@ -130,8 +130,6 @@ config DEBUG_WX
 
 	  This is useful for discovering cases where the kernel is leaving W+X
 	  mappings after applying NX, as such mappings are a security risk.
-	  This check also includes UXN, which should be set on all kernel
-	  mappings.
 
 	  Look for a message in dmesg output like this:
 
_

Patches currently in -mm which might be from zong.li@sifive.com are

mm-add-debug_wx-support.patch
mm-add-debug_wx-support-fix-3.patch
riscv-support-debug_wx.patch
x86-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
