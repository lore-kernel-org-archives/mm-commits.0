Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914CBC2BB41
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242169AbiHQU5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242172AbiHQU5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB242AB043
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C4C1614C4
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEEDC433C1;
        Wed, 17 Aug 2022 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769823;
        bh=SoniG6lBjiFBe+EHJuiG4F/KCbagKNIG/HYoV2SF+CI=;
        h=Date:To:From:Subject:From;
        b=ubRFns+GC9PlA2+PoYKpSh/b6HmvPP3miajyzGFbEkvmFe1lsS8F2chH69+8I7W0P
         jUrClkPPNdc8E6R1x76tzCyWDeFTYjeAGtId10Nd9qeAEkzIJPompQkrl8ouj9xbEq
         IDqy50t/Lr0w5zlZ9XzcUJXlgKKKYxqpOmYntCgk=
Date:   Wed, 17 Aug 2022 13:57:03 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] get_maintainer-add-alan-to-get_maintainerignore.patch removed from -mm tree
Message-Id: <20220817205703.DBEEDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: get_maintainer: add Alan to .get_maintainer.ignore
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-alan-to-get_maintainerignore.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


