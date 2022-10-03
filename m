Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147B7C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJCVaP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJCV3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB1751439
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067B5601D7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D714C433C1;
        Mon,  3 Oct 2022 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832151;
        bh=GViuaaLVz3/RjhrYC1qx+UxfwGvLFGm59QcxLxozkhg=;
        h=Date:To:From:Subject:From;
        b=VQ8ws084JJ7OIGsx2oJWkzpplx7a8UfgOxd0s1xKMm2fv/0KOJx7mC7hUYF4kLKEt
         tLkAhi8AEniOLFvrIp+dkL9qW0juTvoeeG37WwzQc+ISJHv+Uldn8fpzmvmZq1KKTf
         6tIyV8Ujq7WcFO2+g6tq04NtfDU7uJ9nNEZggpUc=
Date:   Mon, 03 Oct 2022 14:22:30 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        yijiangshan@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] inith-fix-spelling-typo-in-comment.patch removed from -mm tree
Message-Id: <20221003212231.5D714C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init.h: fix spelling typo in comment
has been removed from the -mm tree.  Its filename was
     inith-fix-spelling-typo-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: init.h: fix spelling typo in comment
Date: Mon, 5 Sep 2022 10:10:34 +0800

Fix spelling typo in comment.

Link: https://lkml.kernel.org/r/20220905021034.947701-1-13667453960@163.com
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/init.h~inith-fix-spelling-typo-in-comment
+++ a/include/linux/init.h
@@ -134,7 +134,7 @@ static inline initcall_t initcall_from_e
 
 extern initcall_entry_t __con_initcall_start[], __con_initcall_end[];
 
-/* Used for contructor calls. */
+/* Used for constructor calls. */
 typedef void (*ctor_fn_t)(void);
 
 struct file_system_type;
_

Patches currently in -mm which might be from yijiangshan@kylinos.cn are


