Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ADDC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 21:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1BF22510
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 21:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbhAYVzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732827AbhAYVym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:54:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1714521D94;
        Mon, 25 Jan 2021 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611611635;
        bh=9xdmdPl8kLAeriDsGS8JdspBdf8J7u0f0nMbhf2VuGQ=;
        h=Date:From:To:Subject:From;
        b=REjXvo2uTOWmOpFWJ6+UEJjWz3SwY2a3Udk+z0Fm0K2zso7M/nHZkwE1dkO91wBPp
         HabjBy2b4A4tOS1kqmTCj+q0CcGIkeOY/vRATb5UGcLayb+Yd1v4e2RWIaJSl7hPrL
         PZY/UtUpxeurLqcgRtzxefKtSlICHO4rN5VJFnqw=
Date:   Mon, 25 Jan 2021 13:53:54 -0800
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + ntfs-layouth-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20210125215354.v35JtogiQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: layout.h: delete duplicated words
has been added to the -mm tree.  Its filename is
     ntfs-layouth-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-layouth-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-layouth-delete-duplicated-words.patch

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
Subject: ntfs: layout.h: delete duplicated words

Drop the repeated words "the" and "in" in comments.

Link: https://lkml.kernel.org/r/20210125194937.24627-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/layout.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/layout.h~ntfs-layouth-delete-duplicated-words
+++ a/fs/ntfs/layout.h
@@ -703,7 +703,7 @@ typedef struct {
 /* 14*/	le16 instance;		/* The instance of this attribute record. This
 				   number is unique within this mft record (see
 				   MFT_RECORD/next_attribute_instance notes in
-				   in mft.h for more details). */
+				   mft.h for more details). */
 /* 16*/	union {
 		/* Resident attributes. */
 		struct {
@@ -1838,7 +1838,7 @@ typedef struct {
  * Also, each security descriptor is stored twice in the $SDS stream with a
  * fixed offset of 0x40000 bytes (256kib, the Windows cache manager's max size)
  * between them; i.e. if a SDS_ENTRY specifies an offset of 0x51d0, then the
- * the first copy of the security descriptor will be at offset 0x51d0 in the
+ * first copy of the security descriptor will be at offset 0x51d0 in the
  * $SDS data stream and the second copy will be at offset 0x451d0.
  */
 typedef struct {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hexagon-remove-config_experimental-from-defconfigs.patch
ntfs-layouth-delete-duplicated-words.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch

