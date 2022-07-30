Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7219CC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiG3BNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239748AbiG3BN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B878AED7
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 510A561CF1
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A47C433C1;
        Sat, 30 Jul 2022 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143599;
        bh=eP3Cx3hJ3Mae7BtpYzmaWcCvPjbM/sRBssqlfMMIMKM=;
        h=Date:To:From:Subject:From;
        b=sRweAct+wbCi3Wn+Z1Qa+OwsUK5ttIa1wN0D7XH9GpJoW19pbN5TQ5dcbKEYX/PT1
         WONuyOdAH8auXTroo6juFEHhhHBFqwa/Sdajeeb+SfFk2cIgkHd0LOia7e/hneeE1u
         ZGnOUgy/9DpwwtD2HCkvA+H4V14GjnvAbt6ShYZE=
Date:   Fri, 29 Jul 2022 18:13:19 -0700
To:     mm-commits@vger.kernel.org, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-a-typo-in-a-comment.patch removed from -mm tree
Message-Id: <20220730011319.A6A47C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix a typo in a comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-typo-in-a-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


