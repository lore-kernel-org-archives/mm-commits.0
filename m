Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CB6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJUEen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJUEem (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D441A463
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C9B461DAA
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73154C433B5;
        Fri, 21 Oct 2022 04:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326879;
        bh=itYrgZuNQibcCRZ05s+lBQkxxpX7/9Dbf7RCHavebbw=;
        h=Date:To:From:Subject:From;
        b=aPicZlVAgx6Pzei78hELps8tCxS/n8lhb44DUB5zoEfVuHdwzsSGmiluN4rYH+CH2
         t7CrCTFa9CZoagyrM9y01VdnC0IPGhpphprpVaErAGWqVHs1WvOeN/0jnkhpOfd/gj
         ++Evpq8QJcsXIqalX586m0NQINTYoc/m7CodRkyQ=
Date:   Thu, 20 Oct 2022 21:34:38 -0700
To:     mm-commits@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-dan-carpenters-email-address.patch removed from -mm tree
Message-Id: <20221021043439.73154C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Dan Carpenter's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-dan-carpenters-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mailmap: update Dan Carpenter's email address
Date: Wed, 12 Oct 2022 16:19:39 +0300

My time at Oracle is ending at the end of the month.  Update my email
address accordingly.

Link: https://lkml.kernel.org/r/Y0a+6+5SHMdvUnpg@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-dan-carpenters-email-address
+++ a/.mailmap
@@ -104,6 +104,7 @@ Christoph Hellwig <hch@lst.de>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
+Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@iogearbox.net>
 Daniel Borkmann <daniel@iogearbox.net> <daniel.borkmann@tik.ee.ethz.ch>
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


