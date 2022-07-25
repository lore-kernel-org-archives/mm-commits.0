Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273ABC43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiGYTdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiGYTdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37A613EB6
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 677A1B80E01
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033E4C341CD;
        Mon, 25 Jul 2022 19:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658777588;
        bh=5WkU5SbTamj6E9n34TRDWEEb3yMM/HzXbtf9nQf7b2w=;
        h=Date:To:From:Subject:From;
        b=cWdOAx0d+Cw3Mfosry2BkpGp/gfjOYVrXSw+sr0LmIGVdaXgxIiU0WRjy5702uE8+
         BwpjnGknugz+/FOzC6pSj0vaDx4lfh4oyCTjBg4N8Oi/POJNdPWkVlkwxvS7tbV4iv
         Z1mJXjoZWoh/CoGlDLTMEtCAyjy/SMP8c71IotDA=
Date:   Mon, 25 Jul 2022 12:33:07 -0700
To:     mm-commits@vger.kernel.org, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-a-typo-in-a-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20220725193308.033E4C341CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a typo in a comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-a-typo-in-a-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-a-typo-in-a-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: fix a typo in a comment
Date: Thu, 21 Jul 2022 22:49:48 +0200

s/heartbaet/heartbeat

Link: https://lkml.kernel.org/r/4d4a6786e8ad522bfad6d2401b7f6634f8af0e5d.1658436259.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/heartbeat.c~ocfs2-fix-a-typo-in-a-comment
+++ a/fs/ocfs2/heartbeat.c
@@ -2,7 +2,7 @@
 /*
  * heartbeat.c
  *
- * Register ourselves with the heartbaet service, keep our node maps
+ * Register ourselves with the heartbeat service, keep our node maps
  * up to date, and fire off recovery when needed.
  *
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

ocfs2-remove-some-useless-functions.patch
ocfs2-use-the-bitmap-api-to-simplify-code.patch
ocfs2-fix-a-typo-in-a-comment.patch

