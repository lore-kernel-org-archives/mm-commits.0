Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89155C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8EF2087C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266216;
	bh=s/jDclKu058zpK1kGy9OI2W3nTuiwTxWlTvZNMf5g94=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vDaDqBYsLtY+k+VnEirjwxprEI6QWDSdv25oshFf7DSi/O2Y8tC/y6rpMT57VURp/
	 wOUVhRa6oNetwn64uAoS4zzrKa93xX3ukjKCKLHp/FJzduCWXkK24zSce+tLxzVVd2
	 3wwEyHvhItuIDkML8H1Yn3Qlvz49Z+47JrfLOfZs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHLVDg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHLVDf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA9420774;
        Wed, 12 Aug 2020 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266215;
        bh=s/jDclKu058zpK1kGy9OI2W3nTuiwTxWlTvZNMf5g94=;
        h=Date:From:To:Subject:From;
        b=NhzF6cNf30/AEUBZBKgZqZ4FkrwJjhkfv2vo8z6IoN5UGqqcIjWT4CdIBpKy65FRm
         3lJkpDNo1H8MFv/UzsEVKfnowmZOxgSxpIXDO14JSzMffo/yAyACGMkKsvgt95aKah
         g/hjkt49uSky7EwGFEgpcp678F0C3i4i1uCcV9Vc=
Date:   Wed, 12 Aug 2020 14:03:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 linux-exportfsh-drop-duplicated-word-in-a-comment.patch removed from -mm
 tree
Message-ID: <20200812210335.QmRyl2dn6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/exportfs.h: drop duplicated word in a comment
has been removed from the -mm tree.  Its filename was
     linux-exportfsh-drop-duplicated-word-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


