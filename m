Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAFFC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A380E61104
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIAdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhEIAdd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:33:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95163600D4;
        Sun,  9 May 2021 00:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620520349;
        bh=1+b8vKbaDbHrjYBqLG5tS6FXC1o0pWHALtud5SxoWWY=;
        h=Date:From:To:Subject:From;
        b=AQxDDDS60o24Joo/DuX/pA1ltjRazEWhKNBKut4cY5Hhw1bZNSpNG5rmMpKJHoz4R
         YRTXZjc85wFueLbt8qiT+1NZcclrpBOOoxVwJjkbvA0MC8RytXdTf81s82ES3MH7Nb
         sl+cSc3/4jcq+20Uxz/Kq8ttYV2SIbSAJYP5jd2k=
Date:   Sat, 08 May 2021 17:32:29 -0700
From:   akpm@linux-foundation.org
To:     fenghua.yu@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + ia64-headers-drop-duplicated-words.patch added to -mm
 tree
Message-ID: <20210509003229.DAMjbvZFv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: headers: drop duplicated words
has been added to the -mm tree.  Its filename is
     ia64-headers-drop-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-headers-drop-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-headers-drop-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: headers: drop duplicated words

Delete the repeated words "to" and "the".

Link: https://lkml.kernel.org/r/20210507184837.10754-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pal.h       |    2 +-
 arch/ia64/include/asm/spinlock.h  |    2 +-
 arch/ia64/include/asm/uv/uv_hub.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/include/asm/pal.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/pal.h
@@ -1086,7 +1086,7 @@ static inline long ia64_pal_freq_base(un
 
 /*
  * Get the ratios for processor frequency, bus frequency and interval timer to
- * to base frequency of the platform
+ * the base frequency of the platform
  */
 static inline s64
 ia64_pal_freq_ratios (struct pal_freq_ratio *proc_ratio, struct pal_freq_ratio *bus_ratio,
--- a/arch/ia64/include/asm/spinlock.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/spinlock.h
@@ -26,7 +26,7 @@
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  * The pad bits in the middle are used to prevent the next_ticket number
  * overflowing into the now_serving number.
  *
--- a/arch/ia64/include/asm/uv/uv_hub.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -257,7 +257,7 @@ static inline int uv_numa_blade_id(void)
 	return 0;
 }
 
-/* Convert a cpu number to the the UV blade number */
+/* Convert a cpu number to the UV blade number */
 static inline int uv_cpu_to_blade_id(int cpu)
 {
 	return 0;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-headers-drop-duplicated-words.patch

