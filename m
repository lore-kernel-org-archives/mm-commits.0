Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA0CC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397E820723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026864;
	bh=hJ/099QeJeo82vMiri5703LTZaV6UdHilRyJcZxTLno=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sruFwdN3PeAkvlrJDBjGoS6UtISH46ogfxyxHbZbQBn2CZm3dst3rplvNOJOKUGS4
	 /7/3WR/mBWcaJRCcfAqNRghxXE1NT4S51BFh2vDABBW1yy/JSmLiBiYQrO0ziyjbED
	 f/29L6LvbLSMwLqcBeMO+LAd4I+7vZSj83i55UPQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgHJCeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AEDD206E9;
        Mon, 10 Aug 2020 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026863;
        bh=hJ/099QeJeo82vMiri5703LTZaV6UdHilRyJcZxTLno=;
        h=Date:From:To:Subject:From;
        b=N8VfvdCGcOwuR2XXgjuplBr8JcDv1K4DrUM+wR87i9VpMHr6E/Vm2/yZVJB0mXKQL
         N5CANhkuSF+49OtwhvSuTan4LbKPgFhrXDDK0fItzk/j9ytD1/P+z0fAFtw7nvmQTb
         /TBsxbtGAbI+LIhmJprPY/2ilXD4E8RglEt+QQNU=
Date:   Sun, 09 Aug 2020 19:34:23 -0700
From:   akpm@linux-foundation.org
To:     jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] ocfs2-suballoch-delete-a-duplicated-word.patch
 removed from -mm tree
Message-ID: <20200810023423.M4QvDrB1D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: suballoc.h: delete a duplicated word
has been removed from the -mm tree.  Its filename was
     ocfs2-suballoch-delete-a-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ocfs2: suballoc.h: delete a duplicated word

Drop the repeated word "is" in a comment.

Link: http://lkml.kernel.org/r/20200720001421.28823-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.h~ocfs2-suballoch-delete-a-duplicated-word
+++ a/fs/ocfs2/suballoc.h
@@ -40,7 +40,7 @@ struct ocfs2_alloc_context {
 
 	u64    ac_last_group;
 	u64    ac_max_block;  /* Highest block number to allocate. 0 is
-				 is the same as ~0 - unlimited */
+				 the same as ~0 - unlimited */
 
 	int    ac_find_loc_only;  /* hack for reflink operation ordering */
 	struct ocfs2_suballoc_result *ac_find_loc_priv; /* */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

