From: akpm@linux-foundation.org
Subject: - arm-export-csum_partial_copy_from_user.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:09 -0700
Message-ID: <200705120536.l4C5a9F4002352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370AbXELFgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, frederik.deweerdt@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arm: export csum_partial_copy_from_user
has been removed from the -mm tree.  Its filename was
     arm-export-csum_partial_copy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm: export csum_partial_copy_from_user
From: Frederik Deweerdt <deweerdt@free.fr>

rxrpc uses this.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/armksyms.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/arm/kernel/armksyms.c~arm-export-csum_partial_copy_from_user arch/arm/kernel/armksyms.c
--- a/arch/arm/kernel/armksyms.c~arm-export-csum_partial_copy_from_user
+++ a/arch/arm/kernel/armksyms.c
@@ -76,6 +76,7 @@ EXPORT_SYMBOL(__const_udelay);
 
 	/* networking */
 EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(csum_partial_copy_from_user);
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(__csum_ipv6_magic);
 
_

Patches currently in -mm which might be from deweerdt@free.fr are

origin.patch
git-arm.patch
revoke-core-code.patch
reiser4-sb_sync_inodes.patch
