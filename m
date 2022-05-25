Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78B7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343527AbiEYRtQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245754AbiEYRtD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8C72018E
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8414EB81E92
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AA5C34114;
        Wed, 25 May 2022 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500940;
        bh=wHn6g9qeJUtYAgJ1NTNaR2B4ih4cFS3iXizM3zFut24=;
        h=Date:To:From:Subject:From;
        b=f0ppLcGTPCxZFkGfU3MPt0T+tOM1Ml8tlOT6lmzi5e29hbPpFcrIvWZxXX+FHdT+x
         Q41IDwFlPHza7rnBmafc+TKSokLPj1jnVjvQUIX4rHgJflk/B11iIc979Wof2LNhO9
         Wss0H4oydFFtD+KS0WVFuZyX0gbsg8lXY3zXbTgw=
Date:   Wed, 25 May 2022 10:48:59 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        Julia.Lawall@inria.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-pkeys-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20220525174900.40AA5C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm/pkeys: fix typo in comment
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: selftests/vm/pkeys: fix typo in comment
Date: Sat, 21 May 2022 13:11:30 +0200

Spelling mistake (triple letters) in comment.  Detected with the help of
Coccinelle.

Link: https://lkml.kernel.org/r/20220521111145.81697-80-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/protection_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-fix-typo-in-comment
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1523,7 +1523,7 @@ void test_implicit_mprotect_exec_only_me
 	/*
 	 * Reset the shadow, assuming that the above mprotect()
 	 * correctly changed PKRU, but to an unknown value since
-	 * the actual alllocated pkey is unknown.
+	 * the actual allocated pkey is unknown.
 	 */
 	shadow_pkey_reg = __read_pkey_reg();
 
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are


