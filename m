Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B23C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbiC1UOd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344316AbiC1UO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8865372C
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E5161463
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D38C340ED;
        Mon, 28 Mar 2022 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498365;
        bh=1SAYirTys+UK++6ux9jXpEvF2r7iwTNqn26KNOhmW3Y=;
        h=Date:To:From:Subject:From;
        b=j0xdE2cQSO29wK12gmE4CHolBwn0krALcfNopA9TNIjncrVWgRSvSxJjlvo8SKGUn
         cNSnvfW50TeN44KGbPhhktkVOb3lMQnwN7XVGDrxdTtLfaeNVKxyJ6AGzoKUQx48hR
         TaO9mLTorIRIOyFMoWYsyLAHpKhmx1vy1YhWZrYc=
Date:   Mon, 28 Mar 2022 13:12:44 -0700
To:     mm-commits@vger.kernel.org, Julia.Lawall@inria.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-ptrace-fix-typos-in-comments.patch added to -mm tree
Message-Id: <20220328201245.30D38C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: ptrace: fix typos in comments
has been added to the -mm tree.  Its filename is
     ia64-ptrace-fix-typos-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-ptrace-fix-typos-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-ptrace-fix-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-fix-typos-in-comments.patch
ia64-ptrace-fix-typos-in-comments.patch

