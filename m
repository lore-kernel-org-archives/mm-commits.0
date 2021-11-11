Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4550C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9679A61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhKKC4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A9226103C;
        Thu, 11 Nov 2021 02:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599213;
        bh=DYJLKfvrxAQ12Rc/pHIttmHuz3QaX7wGtkvbOUP26Sc=;
        h=Date:From:To:Subject:From;
        b=Dh0lPkkjfBtveouJ9jSLL1FWiXIAdNQCXkhTtfXRzO7p9UlP4b2JaF6znXyHJAGiX
         Ofgc/35WqM7HXd6OQBJC9WpFcH71KDEpo5S8uCkVXxIufrbH06cnpfqpJoT3SRPmWV
         ZljX7+dp+9ML4mZPodmU+W477g3DCogisyrvmwYU=
Date:   Wed, 10 Nov 2021 18:53:33 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged] coda-bump-module-version-to-72.patch removed
 from -mm tree
Message-ID: <20211111025333.nmnMyvil-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: bump module version to 7.2
has been removed from the -mm tree.  Its filename was
     coda-bump-module-version-to-72.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


