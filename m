Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC39C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FD561245
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbhIOD6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236277AbhIOD6m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23CC60ED7;
        Wed, 15 Sep 2021 03:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678244;
        bh=zfbHKwUz2pIavOge5MR4woZQbFPjRvie6uXHBqKa7yg=;
        h=Date:From:To:Subject:From;
        b=ycplmsCeQ5CWksE73bXtoAFdENALR93oLOoTFdFR6Y/Q4IfwV8eRmbyGE1FssReoB
         Bnl5dKQWxC/zMocodUo3MKkgBp0amvvfsUWGEmtlC3TMnlXiPExPjvnBo47+LWXHsP
         TfZEOOHYjZuJWLHri4LRuXaoy/ISXDkw+1HvZGyQ=
Date:   Tue, 14 Sep 2021 20:57:23 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  + coda-bump-module-version-to-72.patch added to -mm tree
Message-ID: <20210915035723.tKaDU99hK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: bump module version to 7.2
has been added to the -mm tree.  Its filename is
     coda-bump-module-version-to-72.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-bump-module-version-to-72.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-bump-module-version-to-72.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: bump module version to 7.2

Helps with tracking which patches have been propagated upstream and if
users are running the latest known version.

Link: https://lkml.kernel.org/r/20210908140308.18491-10-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/psdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/coda/psdev.c~coda-bump-module-version-to-72
+++ a/fs/coda/psdev.c
@@ -384,7 +384,7 @@ MODULE_AUTHOR("Jan Harkes, Peter J. Braa
 MODULE_DESCRIPTION("Coda Distributed File System VFS interface");
 MODULE_ALIAS_CHARDEV_MAJOR(CODA_PSDEV_MAJOR);
 MODULE_LICENSE("GPL");
-MODULE_VERSION("7.0");
+MODULE_VERSION("7.2");
 
 static int __init init_coda(void)
 {
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch

