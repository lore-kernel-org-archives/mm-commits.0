Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46EBC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiGDBNA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiGDBL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91F86411
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44DC9612F5
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F2C341C6;
        Mon,  4 Jul 2022 01:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897055;
        bh=Izk2iTEfONiUFEGvE3+y1ObsCogQxre17IwT1pXUMRU=;
        h=Date:To:From:Subject:From;
        b=EyiZJZq2U1171WK9mTT8R/1EXScWF1uy+ysSbo93degRaVLjqa/WOgX1y619g/jfB
         PvZaCMbhOq0oWV0aJE8qrCo+gObwq3hJ9z3Ib8o4bNy2lmXgdw5qVpXP9vR6q7HLAb
         knaNqSylzmuP2rSzIncbUa0PnI8KLSJnmKhkh/og=
Date:   Sun, 03 Jul 2022 18:10:55 -0700
To:     mm-commits@vger.kernel.org, chenxuebing@jari.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparsemem-drop-unexpected-word-a-in-comments.patch removed from -mm tree
Message-Id: <20220704011055.990F2C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: sparsemem: drop unexpected word 'a' in comments
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-drop-unexpected-word-a-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "XueBing Chen" <chenxuebing@jari.cn>
Subject: mm: sparsemem: drop unexpected word 'a' in comments
Date: Sat, 25 Jun 2022 16:51:35 +0800 (GMT+08:00)

there is an unexpected word 'a' in the comments that need to be dropped

Link: https://lkml.kernel.org/r/24fbdae3.c86.1819a0f31b9.Coremail.chenxuebing@jari.cn
Signed-off-by: XueBing Chen <chenxuebing@jari.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-sparsemem-drop-unexpected-word-a-in-comments
+++ a/mm/sparse-vmemmap.c
@@ -548,7 +548,7 @@ pte_t * __meminit vmemmap_pte_populate(p
 		} else {
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a a free_pages() call to this page allocated
+			 * there's a free_pages() call to this page allocated
 			 * above. Thus this get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
_

Patches currently in -mm which might be from chenxuebing@jari.cn are


