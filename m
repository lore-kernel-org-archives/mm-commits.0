Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986EDC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7108460E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHW4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHW4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 792B661430;
        Sat,  8 May 2021 22:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514507;
        bh=1DILfNn/SEARDrj6IIpLRdTYsyJnR/PVQqq0a/Pki1Y=;
        h=Date:From:To:Subject:From;
        b=lXMXFJGcCStJ9UnvOAxLhVtU5Dawfy/AN/QDsM0p4sB6dtGU4vCAzvma2+9VREe/D
         DeEzTBYEZsdrerb/whdy3xLC8eLfAI2SMYdQ4LiIK8lhQHJudX8F1zwsdZ9HAvCXgg
         Nw6LZpdi18qZCpgIa0/wdfD5N1m67aVKTG+lEo1Q=
Date:   Sat, 08 May 2021 15:55:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  [merged] kernel-fix-a-typo-in-the-file-upc.patch removed
 from -mm tree
Message-ID: <20210508225507.cDk4RFf-2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/up.c: fix typo
has been removed from the -mm tree.  Its filename was
     kernel-fix-a-typo-in-the-file-upc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: kernel/up.c: fix typo

s/condtions/conditions/

Link: https://lkml.kernel.org/r/20210317032732.3260835-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/up.c~kernel-fix-a-typo-in-the-file-upc
+++ a/kernel/up.c
@@ -38,7 +38,7 @@ EXPORT_SYMBOL(smp_call_function_single_a
 
 /*
  * Preemption is disabled here to make sure the cond_func is called under the
- * same condtions in UP and SMP.
+ * same conditions in UP and SMP.
  */
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask)
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


