Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016F7C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 03:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB432078D
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 03:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597375014;
	bh=g35qmKgpwXXd2PE3EKCbo2NlEpZhvhFEORU3F6HbX+I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Na9SN6J+d1o3ffiNp+im2T4/Cuy4SSvGNARf+A3xq1h74OkXjiGhmGADjA9dsGU9l
	 FoC+hT6pL6Puk9JzrwPDTcKerHhFyA+CgWKdX3GM252zcf2+vpcH0UEVObPDD5b2QM
	 Z+zPsvPFZqYhpdpS8R0QT9PuUk3ufB38kp92mztA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHNDQy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Aug 2020 23:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgHNDQy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Aug 2020 23:16:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92BF520715;
        Fri, 14 Aug 2020 03:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597375013;
        bh=g35qmKgpwXXd2PE3EKCbo2NlEpZhvhFEORU3F6HbX+I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hm516d3rwa9JxZ49YrdbxhsabvPfSu6tEQ2Pd3XrfneuUA7mKPvmnT1/iwHn/mMos
         SJxbkxFuuBGCxzYznVgwxWO3TwRskRrx6cDuxrbSg2HyN/7x5ouWA0sQmbxwZdoQ9u
         ArxbiW9y2kZOIhXtnmwn/i9LktXW/IThuSkks6aM=
Date:   Thu, 13 Aug 2020 20:16:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, raven@themaw.net, rdunlap@infradead.org
Subject:  + fs-autofs-delete-repeated-words-in-comments.patch added
 to -mm tree
Message-ID: <20200814031653.PAbtnAbps%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: autofs: delete repeated words in comments
has been added to the -mm tree.  Its filename is
     fs-autofs-delete-repeated-words-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-autofs-delete-repeated-words-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-autofs-delete-repeated-words-in-comments.patch

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
Subject: fs: autofs: delete repeated words in comments

Drop duplicated words {the, at} in comments.

Link: http://lkml.kernel.org/r/20200811021817.24982-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~fs-autofs-delete-repeated-words-in-comments
+++ a/fs/autofs/dev-ioctl.c
@@ -20,7 +20,7 @@
  * another mount. This situation arises when starting automount(8)
  * or other user space daemon which uses direct mounts or offset
  * mounts (used for autofs lazy mount/umount of nested mount trees),
- * which have been left busy at at service shutdown.
+ * which have been left busy at service shutdown.
  */
 
 typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
@@ -496,7 +496,7 @@ static int autofs_dev_ioctl_askumount(st
  * located path is the root of a mount we return 1 along with
  * the super magic of the mount or 0 otherwise.
  *
- * In both cases the the device number (as returned by
+ * In both cases the device number (as returned by
  * new_encode_dev()) is also returned.
  */
 static int autofs_dev_ioctl_ismountpoint(struct file *fp,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-autofs-delete-repeated-words-in-comments.patch

