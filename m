Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6C8C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGQXa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQXa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1F1262B
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45BC60EF0
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026DBC341CE;
        Sun, 17 Jul 2022 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100656;
        bh=y5YkTVWugdtRU3dfdOCocdK9+5zEGn94srwC+5CjbS8=;
        h=Date:To:From:Subject:From;
        b=DTXzxGuJTykjVWT8wUxLGyzsmqibBIZEoviU3/ifgOwq3mb0X7d+iYWoXwZB7M3wp
         rHjHIE2ub6c+vAOP6Ciue/tt9/TCuxLqD5eOK71QMddkpFyLL3E1x4x2bSl3vHvAhS
         CLzp8fqYubItfzlzlFhyppV3rnwCkjfEfyN4aYew=
Date:   Sun, 17 Jul 2022 16:30:55 -0700
To:     mm-commits@vger.kernel.org, chenhuacai@kernel.org,
        rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] loongarch-drop-definition-of-pgd_order-v2.patch removed from -mm tree
Message-Id: <20220717233056.026DBC341CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: loongarch: drop definition of PGD_ORDER
has been removed from the -mm tree.  Its filename was
     loongarch-drop-definition-of-pgd_order-v2.patch

This patch was dropped because it was folded into loongarch-drop-definition-of-pgd_order.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: loongarch: drop definition of PGD_ORDER
Date: Tue, 5 Jul 2022 18:47:05 +0300

drop extra BLANK() line in arch/loongarch/kernel/asm-offsets.c

Link: https://lkml.kernel.org/r/20220705154708.181258-13-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/asm-offsets.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/loongarch/kernel/asm-offsets.c~loongarch-drop-definition-of-pgd_order-v2
+++ a/arch/loongarch/kernel/asm-offsets.c
@@ -190,7 +190,6 @@ void output_mm_defines(void)
 #endif
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
-	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
 	BLANK();
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch
arm-heads-rename-pmd_order-to-pmd_entry_order.patch

