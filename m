Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F407EC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D050C2080D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291646;
	bh=+ytSvAwh3SoyYWr6gCrYdQ4MCIiwSF2YPBcU8iPaTKE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nQn+dT4jeGWXSiGUTzdUoN9F3aZZqgf3vBrZwF0x+BswLr7LJ/VVydcp1zo7ARFe0
	 pWmnfwtAYXuUR0sfuuPyUsF7mj9Ecl+zqTjlkRV+Mw12uozZ9FUJXMn/vtVt50zv8d
	 Mdzub9hP8vaB0Cv3+Ah6C980CTxwXKk71y9AtLEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgGUAeG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgGUAeG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:34:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D37207FC;
        Tue, 21 Jul 2020 00:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291645;
        bh=+ytSvAwh3SoyYWr6gCrYdQ4MCIiwSF2YPBcU8iPaTKE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zux7XXpCHLVyWS3XC4eW4jlN8kmE/asX98bZ99wnaak2Y1EZhui1ZOb7sGmWLnqF5
         9T4C6Llp0jQNJwvaBqyefRINXudUlFzKRrln95Q3i5CKq6eI800qULuXg/SNZjPk7Q
         DVx/Nf2mKLWJp9v0iK3b3cCPEHD5/DkIAY+xv3Io=
Date:   Mon, 20 Jul 2020 17:34:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     lasse.collin@tukaani.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + xz-drop-duplicated-word-in-linux-xzh.patch added to -mm
 tree
Message-ID: <20200721003405.MlFBE1tld%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/xz.h: drop duplicated word
has been added to the -mm tree.  Its filename is
     xz-drop-duplicated-word-in-linux-xzh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xz-drop-duplicated-word-in-linux-xzh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xz-drop-duplicated-word-in-linux-xzh.patch

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
Subject: include/linux/xz.h: drop duplicated word

Drop the doubled word "than" in a comment.

Link: http://lkml.kernel.org/r/05ebba7a-c1e4-01ae-fc7b-15c081b33f3e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xz.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/xz.h~xz-drop-duplicated-word-in-linux-xzh
+++ a/include/linux/xz.h
@@ -28,7 +28,7 @@
  * enum xz_mode - Operation mode
  *
  * @XZ_SINGLE:              Single-call mode. This uses less RAM than
- *                          than multi-call modes, because the LZMA2
+ *                          multi-call modes, because the LZMA2
  *                          dictionary doesn't need to be allocated as
  *                          part of the decoder state. All required data
  *                          structures are allocated at initialization,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

