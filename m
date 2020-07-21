Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4939AC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E312080D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291412;
	bh=LZe7EhKPwN8QLztG6uypPR1HIdRBpRdkY8pML1nYtMI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JZfEk1QYKMJ17KfLC9WrHhrY02zQ08id1XuIoYdCnIW4dz+7AeuThZTYOcRXvFM0X
	 oFjF+xkaBn+3BTZGProqdRhvwAcGiMkfm5TH0RHem0KfNvBjAQy7zY4bTbJJWSZR0H
	 huMvJBDdLwfjbTLd/7yg3+XZOuJRqe3oD10W9rns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGUAaL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgGUAaL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:30:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5656207FC;
        Tue, 21 Jul 2020 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291411;
        bh=LZe7EhKPwN8QLztG6uypPR1HIdRBpRdkY8pML1nYtMI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eLRkdiDWsLlA7fUxIhqd3VSpnNvoUL1p2kOC+8ChaW789YffKgyE7fxbS0AsnGcC1
         srlB1xZ3hDxEER9QhvvqqzfruOQXe5ZfUrYqBDA41emlYsFQWX1vc0gTphYKomAJZ0
         uvAx3zNyXeh6XKfmAb65DqBITeU+KnTogtd+7M3U=
Date:   Mon, 20 Jul 2020 17:30:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject:  + linux-exportfsh-drop-duplicated-word-in-a-comment.patch
 added to -mm tree
Message-ID: <20200721003010.0uOul2n7E%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/exportfs.h: drop duplicated word in a comment
has been added to the -mm tree.  Its filename is
     linux-exportfsh-drop-duplicated-word-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-exportfsh-drop-duplicated-word-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-exportfsh-drop-duplicated-word-in-a-comment.patch

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
Subject: include/linux/exportfs.h: drop duplicated word in a comment

Drop the doubled word "a" in a comment.

Link: http://lkml.kernel.org/r/c61b707a-8fd8-5b1b-aab0-679122881543@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/exportfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/exportfs.h~linux-exportfsh-drop-duplicated-word-in-a-comment
+++ a/include/linux/exportfs.h
@@ -178,7 +178,7 @@ struct fid {
  * get_name:
  *    @get_name should find a name for the given @child in the given @parent
  *    directory.  The name should be stored in the @name (with the
- *    understanding that it is already pointing to a a %NAME_MAX+1 sized
+ *    understanding that it is already pointing to a %NAME_MAX+1 sized
  *    buffer.   get_name() should return %0 on success, a negative error code
  *    or error.  @get_name will be called without @parent->i_mutex held.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
autofs-fix-doubled-word.patch

