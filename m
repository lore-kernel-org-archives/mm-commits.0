Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3118C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 30 Mar 2021 00:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEFC161987
	for <mm-commits@archiver.kernel.org>; Tue, 30 Mar 2021 00:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhC3Asn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhC3AsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 29 Mar 2021 20:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1334861987;
        Tue, 30 Mar 2021 00:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617065299;
        bh=bAP7+NO9Hr9Kb9Vb+sJ/DAboCt0rG2UqMnraaEfZrX0=;
        h=Date:From:To:Subject:From;
        b=LFhTcA/RXrNgTRGZsfGiPgQz24t+Y49Qcjz40xkNSN5ejJughpgkUJn6JzGHUWX9j
         eY1AByick7a7YVw2B84ZlIaWrxItC5JMR8kjIcN/jmR+7WtbbgVHe0es+Dnq52vKE/
         mHoDZtGzGoeZFpSQgALVwghDvyiQyxzs0nfi//tA=
Date:   Mon, 29 Mar 2021 17:48:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20210330004818.3XjtWUum9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/bitmap.h~linux-next-rejects
+++ a/include/linux/bitmap.h
@@ -5,10 +5,12 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/align.h>
-#include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/limits.h>
 #include <linux/string.h>
+#include <linux/types.h>
+
+struct device;
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-check-page-posion-status-for-coredump-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-rejects.patch

