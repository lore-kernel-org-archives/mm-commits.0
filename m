Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3394C25B07
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 22:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiHJW3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 18:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiHJW3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 18:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFE88D3F8
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 15:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DD8BB81E93
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 22:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563AEC433D6;
        Wed, 10 Aug 2022 22:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660170556;
        bh=5CFRU6oSLfRA9hbz0GZdKCT26fau5DOeZVsxj15Atuw=;
        h=Date:To:From:Subject:From;
        b=1b8cwwbqG6Bzok8ZEKXImlCEopU9t7YXZD2WAVfQgiR3mlJRaDXaDp3L7163UStLo
         w/9lKkxF5VjF5x/oOOshp1bUIoXteEtSgf0ozN3d7DCqIhct6KyHGuuJaZZRbyCSYC
         r83ulwzQ8hr5x7hbaPXr+JajVRrv0stGH/f2olPM=
Date:   Wed, 10 Aug 2022 15:29:15 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-add-alan-to-get_maintainerignore.patch added to mm-hotfixes-unstable branch
Message-Id: <20220810222916.563AEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add Alan to .get_maintainer.ignore
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     get_maintainer-add-alan-to-get_maintainerignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-alan-to-get_maintainerignore.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: get_maintainer: add Alan to .get_maintainer.ignore
Date: Wed, 10 Aug 2022 12:18:08 +0300

Alan asked to be added to the .get_maintainer.ignore list.

Link: https://lkml.kernel.org/r/YvN30KhO9aD5Sza9@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/.get_maintainer.ignore~get_maintainer-add-alan-to-get_maintainerignore
+++ a/.get_maintainer.ignore
@@ -1,2 +1,4 @@
+Alan Cox <alan@lxorguk.ukuu.org.uk>
+Alan Cox <root@hraefn.swansea.linux.org.uk>
 Christoph Hellwig <hch@lst.de>
 Marc Gonzalez <marc.w.gonzalez@free.fr>
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

get_maintainer-add-alan-to-get_maintainerignore.patch

