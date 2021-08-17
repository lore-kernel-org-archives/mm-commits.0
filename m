Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76B5C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B94361042
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhHQT1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 15:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhHQT1w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 15:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A9061008;
        Tue, 17 Aug 2021 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629228438;
        bh=ZIRaLLXl7lV0dPpk5m5/+Gwj/P1dk582EIRPbOH75hU=;
        h=Date:From:To:Subject:From;
        b=ItplrVoA5Qy1dquFp8Za5sZSIXD7ZU7oZwviCWsRnwts0DsKaDSCqQzlpRBpPbgKX
         qKkLmIjSdl5IOCooOHbf8xe4C67cJ4XalX8AGprHKtH6GPw7GkgT7REf6AiwuhRH3a
         Df+gHXUI6YlQSVYyCFUiXH/7lxmUswaNSRV0Ot0Y=
Date:   Tue, 17 Aug 2021 12:27:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangborong@cdjrlc.com
Subject:  + ia64-fix-typo-in-a-comment.patch added to -mm tree
Message-ID: <20210817192718.ljD4i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix typo in a comment
has been added to the -mm tree.  Its filename is
     ia64-fix-typo-in-a-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-typo-in-a-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-typo-in-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-fix-typo-in-a-comment.patch

