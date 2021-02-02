Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94833C433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6566564F58
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbhBBTvE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240092AbhBBTrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAB7564DBA;
        Tue,  2 Feb 2021 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612295199;
        bh=TnMJIIp18YbIF7Sncr9q2CNl0QSdnUP7LIVQ5FSc/Cw=;
        h=Date:From:To:Subject:From;
        b=OOy9AjTtn3NvotFR1ALNMdDBiqS0LrKb2vkNSATDsqq2Y4roMYS8MkgCAfCpxIM9P
         TJzUlF5mar6sr+Y8YQwOQp4zc1ZiqonYOrg7PRlS7tZtTslA/2KsMMEom7ij9fjy3i
         29+lBFRPU1/4b7URs5nSTq3Vt1VPE1S3C3Npb7PA=
Date:   Tue, 02 Feb 2021 11:46:38 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-hugetlbc-fix-typos-in-comments.patch added to -mm
 tree
Message-ID: <20210202194638.gi23TYR3d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix typos in comments
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-typos-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-fix-typos-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-fix-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/hugetlb.c: fix typos in comments

Fix typo in comment.

Link: https://lkml.kernel.org/r/1612256106-9436-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-typos-in-comments
+++ a/mm/hugetlb.c
@@ -4042,7 +4042,7 @@ void unmap_hugepage_range(struct vm_area
 
 /*
  * This is called when the original mapper is failing to COW a MAP_PRIVATE
- * mappping it owns the reserve page for. The intention is to unmap the page
+ * mapping it owns the reserve page for. The intention is to unmap the page
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-hugetlbc-fix-typos-in-comments.patch

