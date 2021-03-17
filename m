Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AC7C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1864D64F20
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCQXkP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCQXjp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1196564F20;
        Wed, 17 Mar 2021 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616024385;
        bh=1WaQTkqZ04GjIFRUjtZTJkTjUp+ocB/NPZD3KSGFDRs=;
        h=Date:From:To:Subject:From;
        b=O5rSHJn1TZgmfq5Kte9W9BgRdDCchN4Z1pgVr4nHjZU+abrRiFFZue+lerpohx5S5
         R3pq5MDYkz9Avm4VDVTItsjYMUvOwomvmsOI/mxQI3RUnATZhIVhe/risVF4LQRdbx
         BG6HKNZgNYarLAwATJnPIvZm6h0nZJ8CCkDhBSBU=
Date:   Wed, 17 Mar 2021 16:39:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + kernel-fix-a-typo-in-the-file-upc.patch added to -mm
 tree
Message-ID: <20210317233944.CtxCl2L3s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/up.c: fix typo
has been added to the -mm tree.  Its filename is
     kernel-fix-a-typo-in-the-file-upc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-fix-a-typo-in-the-file-upc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-fix-a-typo-in-the-file-upc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -67,7 +67,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
 
 /*
  * Preemption is disabled here to make sure the cond_func is called under the
- * same condtions in UP and SMP.
+ * same conditions in UP and SMP.
  */
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask)
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
mm-typo-fix-in-the-file-utilc.patch
kernel-fix-a-typo-in-the-file-upc.patch
lib-fix-a-typo-in-the-file-bchc.patch

