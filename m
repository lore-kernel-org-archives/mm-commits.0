Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4847AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23D44610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhICU4G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhICU4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCC1610CC;
        Fri,  3 Sep 2021 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702506;
        bh=bWWE3cUcbvRKFo0MFGe4uAY4ersDImWUgG0qW/xszqE=;
        h=Date:From:To:Subject:From;
        b=X531hMvdp0Ar7sYm0LX8mkTl0aWdeYRg90/wG1A4KFeliZulBL6R7g0RJ12/CZFP4
         1bIpSZTvXBlEjmQw7GHO+6RcNpWiiN8ob05BsJnl3dfQ4X0tAzLenZEj46Zou03QZN
         m1bdBb9oOB+21Vh6COqORGRIvOIifqgGAKJnDfCg=
Date:   Fri, 03 Sep 2021 13:55:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangborong@cdjrlc.com
Subject:  [merged] ia64-fix-typo-in-a-comment.patch removed from
 -mm tree
Message-ID: <20210903205505.GsvfR4xfC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix typo in a comment
has been removed from the -mm tree.  Its filename was
     ia64-fix-typo-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Wang <wangborong@cdjrlc.com>
Subject: ia64: fix typo in a comment

s/when when/when/

Link: https://lkml.kernel.org/r/20210817112500.12848-1-wangborong@cdjrlc.com
Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/acpi.c~ia64-fix-typo-in-a-comment
+++ a/arch/ia64/kernel/acpi.c
@@ -906,6 +906,6 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
 /*
  * acpi_suspend_lowlevel() - save kernel state and suspend.
  *
- * TBD when when IA64 starts to support suspend...
+ * TBD when IA64 starts to support suspend...
  */
 int acpi_suspend_lowlevel(void) { return 0; }
_

Patches currently in -mm which might be from wangborong@cdjrlc.com are


