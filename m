Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F63FC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EEC62080D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291415;
	bh=XM//HMR+T2VUJnExglgF/kATds8Sve4RDWWlGkkG79I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kZw2dMhx6Fw3q1Fa+zngTA+mS0vorOFofPATIpPdtFMySeM+Ow1wYqLYfmZBJ6L1K
	 O9NuYb5fZ83hDe7jHKidi3blluuh9fS9EkFzZvbnL0cibJPhj0lmhBDtCCpCHN/BhR
	 12keCAf3Yq/1WO/MzE7NZl/+TyoeSv8il8Podf+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGUAaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgGUAaO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:30:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8742080D;
        Tue, 21 Jul 2020 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291412;
        bh=XM//HMR+T2VUJnExglgF/kATds8Sve4RDWWlGkkG79I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wUer2Y070TcBEnNI8VbZI71PbOQ0rwHcnae44dj4HcxMEf7kX3dHnHqMIk/lqA5Ud
         futyke19L2bjGMtuRuZ1fP0qaOF/boDoqru2UxWzZ1bGQqjUtCemDHY9I8vv/Owi5p
         kahKXtxiEa8jI1/0pusVKegFmByVn81Kkw9eWZtw=
Date:   Mon, 20 Jul 2020 17:30:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.j.williams@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + linux-async_txh-drop-duplicated-word-in-a-comment.patch
 added to -mm tree
Message-ID: <20200721003012.CX58J_b3m%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/async_tx.h: drop duplicated word in a comment
has been added to the -mm tree.  Its filename is
     linux-async_txh-drop-duplicated-word-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-async_txh-drop-duplicated-word-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-async_txh-drop-duplicated-word-in-a-comment.patch

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
Subject: include/linux/async_tx.h: drop duplicated word in a comment

Drop the doubled word "the" in a comment.

Link: http://lkml.kernel.org/r/e85802f7-8f48-8b4c-29b3-ea237a2c7ae9@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/async_tx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/async_tx.h~linux-async_txh-drop-duplicated-word-in-a-comment
+++ a/include/linux/async_tx.h
@@ -36,7 +36,7 @@ struct dma_chan_ref {
 /**
  * async_tx_flags - modifiers for the async_* calls
  * @ASYNC_TX_XOR_ZERO_DST: this flag must be used for xor operations where the
- * the destination address is not a source.  The asynchronous case handles this
+ * destination address is not a source.  The asynchronous case handles this
  * implicitly, the synchronous case needs to zero the destination block.
  * @ASYNC_TX_XOR_DROP_DST: this flag must be used if the destination address is
  * also one of the source addresses.  In the synchronous case the destination
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

