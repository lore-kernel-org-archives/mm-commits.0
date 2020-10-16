Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1648AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD38B2145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881593;
	bh=VBOXYqP59Q0RhpDbicCfSN5pb/yr/4mBqCyCBtSR7CE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FsW9fOjcpRftgLWlfxSTMQWs163AN+zHYi7mpWFsUK8fnW41z9JRTB7rNJ1Nc9dTk
	 90B7em6PEFS6tmeTRIJoGjExATixX33aulF59s7r9WK98X33oyN3hg0g8jTuozdSoX
	 O2gmoAeK2JwtUoBYOUymrELiWuoe6GqX3VO6ouzA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409121AbgJPUxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409109AbgJPUxN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC98205CB;
        Fri, 16 Oct 2020 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881592;
        bh=VBOXYqP59Q0RhpDbicCfSN5pb/yr/4mBqCyCBtSR7CE=;
        h=Date:From:To:Subject:From;
        b=HVL69nLU9YtR+2tLmg02mWD3KL/VI5NkAJZRTVK9q2MJJZIDlEL7zRbcgsW3TgwI4
         64MSqCU1TZgtkSGAG2jXMJ8SLEsouz8t++CX4BFQxS/yRff/c1Cox9//lkFQHYuGyG
         N3KHEuacdUNftEuAAa3E33P81bIxMeLW3NBcZ3tA=
Date:   Fri, 16 Oct 2020 13:53:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-test_sysctl-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20201016205312.d_WTVBTOT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test_sysctl: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-test_sysctl-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: test_sysctl: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040520.1999-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_sysctl.c~lib-test_sysctl-delete-duplicated-words
+++ a/lib/test_sysctl.c
@@ -16,7 +16,7 @@
  */
 
 /*
- * This module provides an interface to the the proc sysctl interfaces.  This
+ * This module provides an interface to the proc sysctl interfaces.  This
  * driver requires CONFIG_PROC_SYSCTL. It will not normally be loaded by the
  * system unless explicitly requested by name. You can also build this driver
  * into your kernel.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


