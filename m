Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F50CC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A4766134F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbhKIChl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 771FF61279;
        Tue,  9 Nov 2021 02:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425295;
        bh=CJN4s0xygnI8tl6Yxu0LL8KW9qycizUhcXN81+Jzhe8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pHVgAeL3gcm3xA+cssq2FKAAKWiSB6zKHjokhuJpNHjYYINGpnLReoG7EUpkFNnnE
         pp5pTUTLugdGVbuUqlLvMHrCjsqeUsyvujZftC+lHVFDt4JfxIdaaqwI1zPcpCFRqn
         KHZr//IKeFSKhiyqvY7lSz/QWNkjU7B2K2TzL6cU=
Date:   Mon, 08 Nov 2021 18:34:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 65/87] coda: bump module version to 7.2
Message-ID: <20211109023455.ztAvo5Wgt%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
