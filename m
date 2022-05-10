Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7127EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiEJEXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5AA1AEC5D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6916F61766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E6AC385C2;
        Tue, 10 May 2022 04:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156241;
        bh=QS7P5z+oZNerjJgvHWJ4JqAxprEeqgasTR71BjAbhJs=;
        h=Date:To:From:Subject:From;
        b=th3w5TcDkCfV3/jAaHfIpHbpEMANQ+XZuoSlAOVSImK02OvOv7cr5xcsDWXQOEQce
         65q0BuSi3Ou5DX1NafhZk6ZbQffcoo8sVFAxlqqYURv7g0Bw0OY0r7lIH++8bSIN4K
         jo8NsDyOexEOsoN4cskHxAFWY5FiIxn2CnM9/6YU=
Date:   Mon, 09 May 2022 21:17:21 -0700
To:     mm-commits@vger.kernel.org, Julia.Lawall@inria.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-ptrace-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20220510041721.C0E6AC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: ptrace: fix typos in comments
has been removed from the -mm tree.  Its filename was
     ia64-ptrace-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: ia64: ptrace: fix typos in comments

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Link: https://lkml.kernel.org/r/20220318103729.157574-23-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/ptrace.c~ia64-ptrace-fix-typos-in-comments
+++ a/arch/ia64/kernel/ptrace.c
@@ -2025,7 +2025,7 @@ static void syscall_get_args_cb(struct u
 	 * - epsinstruction: cfm is set by br.call
 	 *   locals don't exist.
 	 *
-	 * For both cases argguments are reachable in cfm.sof - cfm.sol.
+	 * For both cases arguments are reachable in cfm.sof - cfm.sol.
 	 * CFM: [ ... | sor: 17..14 | sol : 13..7 | sof : 6..0 ]
 	 */
 	cfm = pt->cr_ifs;
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are


