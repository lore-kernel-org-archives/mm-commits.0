Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8974C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9562464FA3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhBYTRB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234250AbhBYTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F7864F18;
        Thu, 25 Feb 2021 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280284;
        bh=Nx59N0xNJSEr/hEs32E6rFROOp7eAPeONlwu31+LOO4=;
        h=Date:From:To:Subject:From;
        b=dhY0SWFNxtHHDO0jmWW05lQT4K+Sxb6Ur6TqTt1KjOxa6PrrtTngQy7G3PrG8oNKB
         POWkm2gnDBTUKLXyCnUtSldrsJEmygtv9WnpKdLn2bNsIye+0JJBdboannL3bhoqzV
         knkc7I0mrKVX/luEfvHXunguazVDV/mPX2767pcc=
Date:   Thu, 25 Feb 2021 11:11:24 -0800
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] ntfs-layouth-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20210225191124.QdWSQPYjr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: layout.h: delete duplicated words
has been removed from the -mm tree.  Its filename was
     ntfs-layouth-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
include-linux-remove-repeated-words.patch
kernel-delete-repeated-words-in-comments.patch

