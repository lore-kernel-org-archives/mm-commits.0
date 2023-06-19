Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C588EC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFSUUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjFSUUl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730B610C6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5434260EBF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA400C433C0;
        Mon, 19 Jun 2023 20:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206023;
        bh=8lagwYs3JeCTWsfHIRpI/NXCeTF+VqTGgLQLmrh7Usk=;
        h=Date:To:From:Subject:From;
        b=l63AZWDJ85LWE1SC70knMNGDltAMpBegWNJL3bvCPOGfojQr+3tSEw5cEXILwadHg
         +PTdUKJa7n6c/co+lcEEDyD3YTE8RmsKD3I/p0B+S1/3ATN+CzPo0TFAEObgVefqPo
         4bw1BCDug67We/uxfiJqGmvnZ2xn8B0Q9MeEUndw=
Date:   Mon, 19 Jun 2023 13:20:23 -0700
To:     mm-commits@vger.kernel.org, ben-linux@fluff.org,
        ben.dooks@sifive.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-ben-dooks.patch removed from -mm tree
Message-Id: <20230619202023.AA400C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entries for Ben Dooks
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-ben-dooks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ben Dooks <ben.dooks@sifive.com>
Subject: mailmap: add entries for Ben Dooks
Date: Thu, 15 Jun 2023 09:18:20 +0100

I am going to be losing my sifive.com address soon and I also realised my
old Simtec address (from >10 years ago) is also not been updates so update
.mailmap for both.

Link: https://lkml.kernel.org/r/20230615081820.79485-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-ben-dooks
+++ a/.mailmap
@@ -70,6 +70,8 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
+Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
+Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
 Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
_

Patches currently in -mm which might be from ben.dooks@sifive.com are


