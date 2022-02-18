Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3622C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 18:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiBRSix (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Feb 2022 13:38:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbiBRSiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Feb 2022 13:38:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9627429C121
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 10:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 560CEB826A7
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 18:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB754C340E9;
        Fri, 18 Feb 2022 18:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645209513;
        bh=DcoaGPLttPpFabfyVFdb4kkmIDGdQcGNskLKC4nIrr4=;
        h=Date:To:From:Subject:From;
        b=XKKjdY0BVj8cOkpGAZba8AhE+YLmWZMQ3BVzM50TNEsfeL0NXCpVsN1qEjGXzqkp5
         7DCTYnncpSeA8MSR+aw6l6xMVLz0QiVzl3yD9rcA4rQnQBX/+nAQf4AiYB2Y2LI5YI
         F0OFgiDV6xPFVn5rJ+8YnAblaD5oh6EE4HrojqxQ=
Date:   Fri, 18 Feb 2022 10:38:32 -0800
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        sfr@canb.auug.org.au, keescook@chromium.org, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-sysctl-next-git-tree.patch added to -mm tree
Message-Id: <20220218183832.DB754C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add sysctl-next git tree
has been added to the -mm tree.  Its filename is
     maintainers-add-sysctl-next-git-tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-sysctl-next-git-tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-sysctl-next-git-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: MAINTAINERS: add sysctl-next git tree

Add a git tree for sysctls as there's been quite a bit of work lately to
remove all the syctls out of kernel/sysctl.c and move to their respective
places, so coordination has been needed to avoid conflicts.  This tree
will also help soak these changes on linux-next prior to getting to Linus.

Link: https://lkml.kernel.org/r/20220218182736.3694508-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-sysctl-next-git-tree
+++ a/MAINTAINERS
@@ -15565,6 +15565,7 @@ M:	Iurii Zaikin <yzaikin@google.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git sysctl-next
 F:	fs/proc/proc_sysctl.c
 F:	include/linux/sysctl.h
 F:	kernel/sysctl-test.c
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-add-sysctl-next-git-tree.patch

