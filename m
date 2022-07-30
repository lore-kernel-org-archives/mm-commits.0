Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31ABC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbiG3BN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiG3BNU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296B38AB2D
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5918B829CB
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CBEC433D7;
        Sat, 30 Jul 2022 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143596;
        bh=Pc+2rY4JfMcGIMzUTuOGYY9SG/VG/IlrmL5FaUlARRU=;
        h=Date:To:From:Subject:From;
        b=HqiomBug/EyDCNBfSyXsnadhx5+cYSHu+EMKdhq+yK/wQWdZRbFN+XLLFfZGXVtGO
         MPL4gUVsFtv6v23x3Y3Bi1pazPNCBwuYWVgvx6IM7t9UKIlzknqcYjriWNT+T+ywG2
         d4+teFuyPJRz7t9+KPVnrKVu040pvJZV5f41Q6/0=
Date:   Fri, 29 Jul 2022 18:13:15 -0700
To:     mm-commits@vger.kernel.org, herberthbli@tencent.com,
        herbert@gondor.apana.org.au, slark_xiao@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-mpi-fix-typo-the-the-in-comment.patch removed from -mm tree
Message-Id: <20220730011316.69CBEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/mpi: fix typo 'the the' in comment
has been removed from the -mm tree.  Its filename was
     lib-mpi-fix-typo-the-the-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Slark Xiao <slark_xiao@163.com>
Subject: lib/mpi: fix typo 'the the' in comment
Date: Fri, 22 Jul 2022 18:19:22 +0800

Replace 'the the' with 'the' in the comment.

Link: https://lkml.kernel.org/r/20220722101922.81126-1-slark_xiao@163.com
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: Hongbo Li <herberthbli@tencent.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpiutil.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/mpi/mpiutil.c~lib-mpi-fix-typo-the-the-in-comment
+++ a/lib/mpi/mpiutil.c
@@ -272,7 +272,7 @@ MPI mpi_set_ui(MPI w, unsigned long u)
 	if (!w)
 		w = mpi_alloc(1);
 	/* FIXME: If U is 0 we have no need to resize and thus possible
-	 * allocating the the limbs.
+	 * allocating the limbs.
 	 */
 	RESIZE_IF_NEEDED(w, 1);
 	w->d[0] = u;
_

Patches currently in -mm which might be from slark_xiao@163.com are


