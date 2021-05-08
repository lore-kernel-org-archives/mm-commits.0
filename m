Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ADAC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC4B61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHW4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHW4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934B860E0B;
        Sat,  8 May 2021 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514513;
        bh=Hj1a/Adh4YQyGgJSoGOxF15PKVNxNHxsVAHzssYs+3E=;
        h=Date:From:To:Subject:From;
        b=N+X4lJezSS5Re1y/NNqD7nvqaw6Q1Swx2vtjQ75CDFUUTpyIJ3/CDkcuvlqIOx7kb
         GjOCS9WJMR8H8+EA6wzfaGuwOescryy4bJPEcBfb5PkUz/iyOhyufgLwyAb5k75yJA
         DoNWWQn7aeDLTZA8SjiFQdPBs4V0+zReeeR/1JOQ=
Date:   Sat, 08 May 2021 15:55:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged] ipc-semc-couple-of-spelling-fixes.patch removed
 from -mm tree
Message-ID: <20210508225513.GHZyjUw73%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: spelling fix
has been removed from the -mm tree.  Its filename was
     ipc-semc-couple-of-spelling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: ipc/sem.c: spelling fix

s/purpuse/purpose/

Link: https://lkml.kernel.org/r/20210319221432.26631-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-semc-couple-of-spelling-fixes
+++ a/ipc/sem.c
@@ -786,7 +786,7 @@ static inline void wake_up_sem_queue_pre
 {
 	get_task_struct(q->sleeper);
 
-	/* see SEM_BARRIER_2 for purpuse/pairing */
+	/* see SEM_BARRIER_2 for purpose/pairing */
 	smp_store_release(&q->status, error);
 
 	wake_q_add_safe(wake_q, q->sleeper);
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


